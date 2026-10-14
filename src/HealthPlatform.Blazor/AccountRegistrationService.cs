using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;

namespace HealthPlatform.Blazor;

public sealed record AccountRegistration(
    string Email,
    string Password,
    string GivenName,
    string FamilyName,
    string? PhoneNumber,
    string AccountType);

public sealed class IdentityUnavailableException(string message) : Exception(message);
public sealed class AccountAlreadyExistsException() : Exception("ACCOUNT_EXISTS");

public sealed class AccountRegistrationService(IHttpClientFactory clients, IConfiguration configuration, ILogger<AccountRegistrationService> logger)
{
    readonly string authority = (configuration["Authentication:Authority"] ?? "http://localhost:8080/realms/health").TrimEnd('/');
    readonly string clientId = configuration["Registration:ClientId"] ?? "health-registration";
    readonly string clientSecret = configuration["Registration:ClientSecret"] ?? string.Empty;
    readonly string tenantId = configuration["Registration:TenantId"] ?? "11111111-1111-1111-1111-111111111111";

    string RealmAdminBase => authority.Replace("/realms/health", "/admin/realms/health", StringComparison.OrdinalIgnoreCase);

    public async Task<bool> IsAvailable(CancellationToken cancellationToken = default)
    {
        try
        {
            using var response = await clients.CreateClient("identity").GetAsync($"{authority}/.well-known/openid-configuration", cancellationToken);
            return response.IsSuccessStatusCode;
        }
        catch (HttpRequestException) { return false; }
        catch (TaskCanceledException) when (!cancellationToken.IsCancellationRequested) { return false; }
    }

    public async Task RegisterAsync(AccountRegistration input, CancellationToken cancellationToken = default)
    {
        var role = input.AccountType.Equals("practitioner", StringComparison.OrdinalIgnoreCase) ? "practitioner" : "patient";
        var token = await GetServiceToken(cancellationToken);
        using var client = clients.CreateClient("identity");
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var username = input.Email.Trim().ToLowerInvariant();
        var attributes = new Dictionary<string, string[]> { ["tenant_id"] = [tenantId] };
        if (!string.IsNullOrWhiteSpace(input.PhoneNumber)) attributes["phone_number"] = [input.PhoneNumber.Trim()];

        var user = new
        {
            username,
            email = username,
            firstName = input.GivenName.Trim(),
            lastName = input.FamilyName.Trim(),
            enabled = true,
            emailVerified = false,
            attributes,
            requiredActions = Array.Empty<string>(),
            credentials = new[] { new { type = "password", value = input.Password, temporary = false } }
        };

        using var create = await client.PostAsJsonAsync($"{RealmAdminBase}/users", user, cancellationToken);
        if (create.StatusCode == HttpStatusCode.Conflict) throw new AccountAlreadyExistsException();
        if (!create.IsSuccessStatusCode)
        {
            logger.LogWarning("Keycloak account creation failed with status {StatusCode}", create.StatusCode);
            throw new IdentityUnavailableException("Le service d’identité a refusé la création du compte.");
        }

        var userId = create.Headers.Location?.Segments.LastOrDefault()?.Trim('/');
        if (string.IsNullOrWhiteSpace(userId))
        {
            var users = await client.GetFromJsonAsync<List<KeycloakUser>>($"{RealmAdminBase}/users?username={Uri.EscapeDataString(username)}&exact=true", cancellationToken);
            userId = users?.SingleOrDefault()?.Id;
        }
        if (string.IsNullOrWhiteSpace(userId)) throw new IdentityUnavailableException("Le compte a été créé, mais son rôle n’a pas pu être configuré.");

        try
        {
            // GET /roles/{name} needs view-realm; the mappable-roles listing only needs the manage-users role the service account already holds.
            var availableRoles = await client.GetFromJsonAsync<JsonElement[]>($"{RealmAdminBase}/users/{userId}/role-mappings/realm/available", cancellationToken) ?? [];
            var roleRepresentation = availableRoles.FirstOrDefault(r => r.TryGetProperty("name", out var name) && name.GetString() == role);
            if (roleRepresentation.ValueKind != JsonValueKind.Object) throw new IdentityUnavailableException("Le rôle du compte n’a pas pu être configuré.");
            using var mapping = await client.PostAsJsonAsync($"{RealmAdminBase}/users/{userId}/role-mappings/realm", new[] { roleRepresentation }, cancellationToken);
            if (!mapping.IsSuccessStatusCode) throw new IdentityUnavailableException("Le rôle du compte n’a pas pu être configuré.");
        }
        catch (Exception ex)
        {
            logger.LogWarning(ex, "Keycloak role mapping failed for new account; rolling back user creation");
            await client.DeleteAsync($"{RealmAdminBase}/users/{userId}", cancellationToken);
            if (ex is IdentityUnavailableException) throw;
            throw new IdentityUnavailableException("Le rôle du compte n’a pas pu être configuré.");
        }
    }

    async Task<string> GetServiceToken(CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(clientSecret)) throw new IdentityUnavailableException("Le service d’inscription n’est pas configuré.");
        using var request = new HttpRequestMessage(HttpMethod.Post, $"{authority}/protocol/openid-connect/token")
        {
            Content = new FormUrlEncodedContent(new Dictionary<string, string>
            {
                ["grant_type"] = "client_credentials",
                ["client_id"] = clientId,
                ["client_secret"] = clientSecret
            })
        };
        try
        {
            using var response = await clients.CreateClient("identity").SendAsync(request, cancellationToken);
            if (!response.IsSuccessStatusCode) throw new IdentityUnavailableException("Le service d’inscription Keycloak n’est pas prêt.");
            using var json = JsonDocument.Parse(await response.Content.ReadAsStringAsync(cancellationToken));
            return json.RootElement.GetProperty("access_token").GetString() ?? throw new IdentityUnavailableException("Jeton de service absent.");
        }
        catch (HttpRequestException ex)
        {
            logger.LogWarning(ex, "Keycloak is unavailable during registration");
            throw new IdentityUnavailableException("Keycloak n’est pas accessible sur le port 8080.");
        }
    }

    sealed record KeycloakUser(string Id);
}
