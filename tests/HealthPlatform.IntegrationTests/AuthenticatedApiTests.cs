using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Security.Cryptography;
using HealthPlatform.Application;
using HealthPlatform.Contracts;
using HealthPlatform.Domain.Identity;
using HealthPlatform.Infrastructure;
using HealthPlatform.Persistence;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;
using MySqlConnector;

namespace HealthPlatform.IntegrationTests;

// Real JWT validation, real HTTP pipeline and real isolated MySQL database.
// No authentication handler or authorization policy is bypassed.
public sealed class AuthenticatedApiTests : IAsyncLifetime
{
    readonly Actor actor = new();
    readonly RSA signing = RSA.Create(2048);
    readonly ECDsa qrKey = ECDsa.Create(ECCurve.NamedCurves.nistP256);
    readonly string database = "hp_test_" + Guid.NewGuid().ToString("N");
    string connection = "";
    WebApplicationFactory<Program> factory = null!;
    HttpClient client = null!;

    HealthDbContext Db() => new(new DbContextOptionsBuilder<HealthDbContext>()
        .UseMySql(connection, new MySqlServerVersion(new Version(8, 0, 36))).Options, actor);

    public async Task InitializeAsync()
    {
        connection = new MySqlConnectionStringBuilder(Environment.GetEnvironmentVariable("HEALTH_TEST_MYSQL")
            ?? "server=localhost;user=root;password=") { Database = database }.ConnectionString;
        await using var db = Db();
        await db.Database.MigrateAsync();
        var org = new Organization(actor.TenantId, "Synthetic Clinic", "CA-QC");
        db.Add(org);
        db.Add(new Practitioner(actor.TenantId, "doctor", "Synthetic Doctor", org.Id, DateTime.UtcNow.AddDays(1), true));
        await db.SaveChangesAsync();

        factory = new WebApplicationFactory<Program>().WithWebHostBuilder(builder =>
        {
            builder.UseEnvironment("Testing");
            builder.ConfigureServices(services =>
            {
                services.RemoveAll<DbContextOptions<HealthDbContext>>();
                services.AddDbContext<HealthDbContext>(o => o.UseMySql(connection, new MySqlServerVersion(new Version(8, 0, 36))));
                services.AddSingleton(new QrCodeService(qrKey.ExportPkcs8PrivateKeyPem(), "integration"));
                services.Configure<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme, o =>
                {
                    o.Authority = null;
                    o.MetadataAddress = null!;
                    o.ConfigurationManager = null!;
                    o.RequireHttpsMetadata = false;
                    o.Configuration = new OpenIdConnectConfiguration { Issuer = "https://test.identity.invalid" };
                    o.TokenValidationParameters.ValidIssuer = "https://test.identity.invalid";
                    o.TokenValidationParameters.ValidAudience = "health-api";
                    o.TokenValidationParameters.IssuerSigningKey = new RsaSecurityKey(signing);
                    o.TokenValidationParameters.ValidateIssuerSigningKey = true;
                });
            });
        });
        client = factory.CreateClient();
    }

    public async Task DisposeAsync()
    {
        client?.Dispose();
        if (factory is not null) await factory.DisposeAsync();
        await using var db = Db();
        await db.Database.EnsureDeletedAsync();
        signing.Dispose();
        qrKey.Dispose();
    }

    void Authenticate(string subject = "patient", string role = "patient", Guid? tenant = null, int mfaAge = 0, string assurance = "2")
    {
        var claims = new[]
        {
            new Claim("sub", subject), new Claim("role", role),
            new Claim("tenant_id", (tenant ?? actor.TenantId).ToString()), new Claim("acr", assurance),
            new Claim("auth_time", (DateTimeOffset.UtcNow.ToUnixTimeSeconds() - mfaAge).ToString(), ClaimValueTypes.Integer64)
        };
        var jwt = new JwtSecurityToken("https://test.identity.invalid", "health-api", claims,
            DateTime.UtcNow.AddSeconds(-1), DateTime.UtcNow.AddMinutes(5),
            new SigningCredentials(new RsaSecurityKey(signing), SecurityAlgorithms.RsaSha256));
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", new JwtSecurityTokenHandler().WriteToken(jwt));
    }

    async Task<PatientDto> Register()
    {
        Authenticate();
        var response = await client.PostAsJsonAsync("/api/v1/patients", new RegisterPatientDto("Synthetic", "Only", new(1990, 1, 1)));
        response.EnsureSuccessStatusCode();
        return (await response.Content.ReadFromJsonAsync<PatientDto>())!;
    }

    [Fact]
    public async Task HttpConsentWorkflowAndReplayProtection()
    {
        var patient = await Register();
        var prefix = $"/api/v1/patients/{patient.Id}";
        var issued = await client.PostAsJsonAsync(prefix + "/access-codes", new IssueQrDto());
        issued.EnsureSuccessStatusCode();
        var qr = (await issued.Content.ReadFromJsonAsync<QrDto>())!;
        Authenticate("doctor", "practitioner");
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync(prefix)).StatusCode);
        Assert.Equal(HttpStatusCode.Accepted, (await client.PostAsJsonAsync("/api/v1/access-codes/scan", new ScanQrDto(qr.QrPayload))).StatusCode);
        Assert.Equal(HttpStatusCode.Conflict, (await client.PostAsJsonAsync("/api/v1/access-codes/scan", new ScanQrDto(qr.QrPayload))).StatusCode);
        Authenticate();
        var requests = (await client.GetFromJsonAsync<List<AccessRequestDto>>(prefix + "/access-requests"))!;
        var request = Assert.Single(requests);
        var approved = await client.PostAsJsonAsync($"/api/v1/access-requests/{request.Id}/decisions", new DecisionDto(true));
        approved.EnsureSuccessStatusCode();
        var decision = (await approved.Content.ReadFromJsonAsync<DecisionResult>())!;
        Assert.Equal(decision.GrantId, Assert.Single((await client.GetFromJsonAsync<List<GrantDto>>(prefix + "/access-grants"))!).Id);
        Authenticate("doctor", "practitioner");
        Assert.Equal(HttpStatusCode.OK, (await client.GetAsync(prefix)).StatusCode);
        Authenticate();
        Assert.Equal(HttpStatusCode.NoContent, (await client.PostAsJsonAsync($"/api/v1/consents/{decision.GrantId}/revoke", new { })).StatusCode);
        var history = (await client.GetFromJsonAsync<List<AuditDto>>(prefix + "/audit-events"))!;
        Assert.Contains(history, a => a.Action == "profile.read" && a.GrantId == decision.GrantId);
        Authenticate("doctor", "practitioner");
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync(prefix)).StatusCode);
    }

    [Fact]
    public async Task CrossTenantAndOtherPatientCannotReadOrIssueQr()
    {
        var patient = await Register();
        var prefix = $"/api/v1/patients/{patient.Id}";
        Authenticate(tenant: Guid.NewGuid());
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync(prefix)).StatusCode);
        Authenticate("other-patient");
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync(prefix)).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await client.PostAsJsonAsync(prefix + "/access-codes", new IssueQrDto())).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync(prefix + "/audit-events")).StatusCode);
        Authenticate("admin", "admin");
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync(prefix)).StatusCode);
    }

    [Fact]
    public async Task InvalidInputsAndStaleMfaAreRejected()
    {
        var patient = await Register();
        var route = $"/api/v1/patients/{patient.Id}/access-codes";
        Assert.Equal(HttpStatusCode.BadRequest, (await client.PostAsJsonAsync(route, new IssueQrDto(601))).StatusCode);
        Authenticate(mfaAge: 301);
        Assert.Equal(HttpStatusCode.Forbidden, (await client.PostAsJsonAsync(route, new IssueQrDto())).StatusCode);
        Authenticate(assurance: "1");
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync("/api/v1/me")).StatusCode);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "not-a-jwt");
        Assert.Equal(HttpStatusCode.Unauthorized, (await client.GetAsync("/api/v1/me")).StatusCode);
    }
}
