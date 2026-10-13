using System.Security.Cryptography;using System.Text;using System.Net.Http.Headers;using System.Net.Http.Json;
namespace HealthPlatform.Mobile;
public sealed class MobileSession {
 // Debug uses adb reverse so Android reaches the host through localhost.
 // Release keeps HTTPS-only placeholders that must be supplied by deployment configuration.
#if DEBUG
 public Uri Authority{get;set;}=new("http://localhost:8080/realms/health/");public Uri Api{get;set;}=new("http://localhost:5100/");
#else
 public Uri Authority{get;set;}=new("https://identity.example.invalid/realms/health/");public Uri Api{get;set;}=new("https://api.example.invalid/");
#endif
 readonly HttpClient http=new();
 static string B64(byte[] b)=>Convert.ToBase64String(b).TrimEnd('=').Replace('+','-').Replace('/','_');
 public async Task Login(){var verifier=B64(RandomNumberGenerator.GetBytes(32));var state=B64(RandomNumberGenerator.GetBytes(32));var challenge=B64(SHA256.HashData(Encoding.ASCII.GetBytes(verifier)));var redirect="healthplatform://callback";var url=new Uri(Authority,"protocol/openid-connect/auth?client_id=health-mobile&response_type=code&scope=openid%20health-api&acr_values=2&max_age=300&redirect_uri="+Uri.EscapeDataString(redirect)+"&state="+state+"&code_challenge_method=S256&code_challenge="+challenge);var result=await WebAuthenticator.Default.AuthenticateAsync(url,new Uri(redirect));if(!result.Properties.TryGetValue("state",out var returned)||returned!=state)throw new InvalidOperationException("Invalid state");if(!result.Properties.TryGetValue("code",out var code))throw new InvalidOperationException("Authorization failed");using var response=await http.PostAsync(new Uri(Authority,"protocol/openid-connect/token"),new FormUrlEncodedContent(new Dictionary<string,string>{{"grant_type","authorization_code"},{"client_id","health-mobile"},{"code",code},{"redirect_uri",redirect},{"code_verifier",verifier}}));response.EnsureSuccessStatusCode();var token=await response.Content.ReadFromJsonAsync<Token>();await SecureStorage.Default.SetAsync("health.access",token!.access_token);}
 public async Task<T?> Get<T>(string route){using var r=new HttpRequestMessage(HttpMethod.Get,new Uri(Api,"api/v1/"+route));r.Headers.Authorization=new AuthenticationHeaderValue("Bearer",await SecureStorage.Default.GetAsync("health.access"));using var response=await http.SendAsync(r);response.EnsureSuccessStatusCode();return await response.Content.ReadFromJsonAsync<T>();}
 public async Task<T?> Post<T>(string route,object input){using var r=new HttpRequestMessage(HttpMethod.Post,new Uri(Api,"api/v1/"+route)){Content=JsonContent.Create(input)};r.Headers.Authorization=new AuthenticationHeaderValue("Bearer",await SecureStorage.Default.GetAsync("health.access"));using var response=await http.SendAsync(r);response.EnsureSuccessStatusCode();return await response.Content.ReadFromJsonAsync<T>();}
 public void Logout()=>SecureStorage.Default.Remove("health.access");
 sealed record Token(string access_token);
}
