using System.Security.Claims;using HealthPlatform.Application;
namespace HealthPlatform.Api;
public sealed class CurrentActor(IHttpContextAccessor http,TimeProvider time):ICurrentActor {
 ClaimsPrincipal User=>http.HttpContext?.User??new();
 public Guid TenantId=>Guid.TryParse(User.FindFirstValue("tenant_id"),out var id)?id:Guid.Empty;
 public string Subject=>User.FindFirstValue("sub")??"";
 public bool IsPatient=>User.IsInRole("patient");public bool IsPractitioner=>User.IsInRole("practitioner");
 public bool RecentMfa=>User.FindFirstValue("acr")=="2"&&long.TryParse(User.FindFirstValue("auth_time"),out var seconds)&&time.GetUtcNow().ToUnixTimeSeconds()-seconds is >=0 and <=300;
 public string CorrelationId=>http.HttpContext?.TraceIdentifier??"background";
}
