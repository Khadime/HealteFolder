using Microsoft.AspNetCore.DataProtection;
using HealthPlatform.Blazor.Components;using HealthPlatform.Blazor;using Microsoft.AspNetCore.Authentication;using Microsoft.AspNetCore.Authentication.Cookies;using Microsoft.AspNetCore.Authentication.OpenIdConnect;using MudBlazor.Services;using Microsoft.FluentUI.AspNetCore.Components;
var builder=WebApplication.CreateBuilder(args);
if (builder.Environment.IsDevelopment())
{
    var environmentFile = Path.GetFullPath(Path.Combine(builder.Environment.ContentRootPath, "..", "..", ".env"));
    if (File.Exists(environmentFile))
    {
        var localSecrets = File.ReadLines(environmentFile)
            .Where(line => !string.IsNullOrWhiteSpace(line) && !line.TrimStart().StartsWith('#') && line.Contains('='))
            .Select(line => line.Split('=', 2))
            .ToDictionary(parts => parts[0].Trim(), parts => parts[1].Trim(), StringComparer.OrdinalIgnoreCase);
        if (string.IsNullOrWhiteSpace(builder.Configuration["Authentication:ClientSecret"]) && localSecrets.TryGetValue("HEALTH_WEB_SECRET", out var webSecret)) builder.Configuration["Authentication:ClientSecret"] = webSecret;
        if (string.IsNullOrWhiteSpace(builder.Configuration["Registration:ClientSecret"]) && localSecrets.TryGetValue("HEALTH_REGISTRATION_SECRET", out var registrationSecret)) builder.Configuration["Registration:ClientSecret"] = registrationSecret;
    }
}
// Development keys remain inside the ignored project secrets directory.
// Production uses the deployment's protected, persistent key ring configuration.
if (builder.Environment.IsDevelopment())
{
    var keyDirectory = builder.Configuration["DataProtection:KeyDirectory"]
        ?? Path.GetFullPath(Path.Combine(builder.Environment.ContentRootPath, "..", "..", ".secrets", "data-protection", "Blazor"));
    builder.Services.AddDataProtection().SetApplicationName("HealthPlatform.Blazor")
        .PersistKeysToFileSystem(new DirectoryInfo(keyDirectory));
}
builder.Services.AddRazorComponents().AddInteractiveServerComponents();builder.Services.AddMudServices();builder.Services.AddFluentUIComponents();builder.Services.AddCascadingAuthenticationState();builder.Services.AddHttpContextAccessor();builder.Services.AddScoped<HealthClient>();builder.Services.AddSingleton<AccountRegistrationService>();builder.Services.AddHttpClient("api",c=>c.BaseAddress=new Uri(builder.Configuration["ApiUrl"]??"http://localhost:5100"));builder.Services.AddHttpClient("identity",c=>c.Timeout=TimeSpan.FromSeconds(5));
builder.Services.AddAuthentication(o=>{o.DefaultScheme=CookieAuthenticationDefaults.AuthenticationScheme;o.DefaultChallengeScheme=OpenIdConnectDefaults.AuthenticationScheme;}).AddCookie(o=>{o.Cookie.HttpOnly=true;o.Cookie.SecurePolicy=CookieSecurePolicy.Always;o.Cookie.SameSite=SameSiteMode.Lax;o.ExpireTimeSpan=TimeSpan.FromMinutes(5);}).AddOpenIdConnect(o=>{o.Authority=builder.Configuration["Authentication:Authority"];o.ClientId="health-web";o.ClientSecret=builder.Configuration["Authentication:ClientSecret"];o.ResponseType="code";o.UsePkce=true;o.SaveTokens=true;o.MapInboundClaims=false;o.RequireHttpsMetadata=!builder.Environment.IsDevelopment();o.Scope.Add("health-api");o.TokenValidationParameters.RoleClaimType="role";o.Events.OnRedirectToIdentityProvider=ctx=>{ctx.ProtocolMessage.AcrValues="2";ctx.ProtocolMessage.MaxAge="300";return Task.CompletedTask;};o.Events.OnRemoteFailure=ctx=>{ctx.HandleResponse();ctx.Response.Redirect("/auth-unavailable");return Task.CompletedTask;};});
builder.Services.AddAuthorization();var app=builder.Build();if(!app.Environment.IsDevelopment()){app.UseHsts();app.UseExceptionHandler("/error");}app.UseHttpsRedirection();app.UseStaticFiles();app.UseAuthentication();app.UseAuthorization();app.UseAntiforgery();
app.MapGet("/login",async(string? returnUrl,AccountRegistrationService identity,CancellationToken ct)=>{
    if(!await identity.IsAvailable(ct))return Results.Redirect("/auth-unavailable");
    var destination=!string.IsNullOrWhiteSpace(returnUrl)&&returnUrl.StartsWith('/')&&!returnUrl.StartsWith("//")?returnUrl:"/";
    return Results.Challenge(new AuthenticationProperties{RedirectUri=destination},[OpenIdConnectDefaults.AuthenticationScheme]);
});
app.MapGet("/logout",()=>Results.SignOut(new AuthenticationProperties{RedirectUri="/"},[CookieAuthenticationDefaults.AuthenticationScheme,OpenIdConnectDefaults.AuthenticationScheme]));
app.MapGet("/forgot-password",()=>Results.Redirect("/login"));
app.MapRazorComponents<App>().AddInteractiveServerRenderMode();app.Run();
