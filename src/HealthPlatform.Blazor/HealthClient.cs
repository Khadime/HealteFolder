using Microsoft.AspNetCore.SignalR.Client;using System.Net.Http.Headers;using System.Net.Http.Json;using Microsoft.AspNetCore.Authentication;
namespace HealthPlatform.Blazor;
public sealed class HealthClient : IAsyncDisposable {
 private Microsoft.AspNetCore.SignalR.Client.HubConnection? hub;
 public async Task Subscribe(Func<Task> refresh){hub=new Microsoft.AspNetCore.SignalR.Client.HubConnectionBuilder().WithUrl(new Uri(client.BaseAddress!,"hubs/access"),o=>o.AccessTokenProvider=()=>Task.FromResult(token)).WithAutomaticReconnect().Build();hub.On<System.Text.Json.JsonElement>("AccessChanged",_=>refresh());await hub.StartAsync();}
 public async ValueTask DisposeAsync(){if(hub!=null)await hub.DisposeAsync();client.Dispose();}
 private readonly HttpClient client;private readonly string? token;
 public HealthClient(IHttpClientFactory factory,IHttpContextAccessor context){client=factory.CreateClient("api");token=context.HttpContext?.GetTokenAsync("access_token").GetAwaiter().GetResult();}
 async Task<HttpResponseMessage> Send(HttpMethod method,string url,object? input=null){var request=new HttpRequestMessage(method,"api/v1/"+url);request.Headers.Authorization=new AuthenticationHeaderValue("Bearer",token);if(input!=null)request.Content=JsonContent.Create(input);var response=await client.SendAsync(request);if(!response.IsSuccessStatusCode)throw new InvalidOperationException(response.StatusCode==System.Net.HttpStatusCode.Unauthorized?"Session expirée. Reconnectez-vous.":"Action refusée ou service indisponible.");return response;}
 public async Task<T?> Get<T>(string url){using var r=await Send(HttpMethod.Get,url);return await r.Content.ReadFromJsonAsync<T>();}
 public async Task<T?> Post<T>(string url,object input){using var r=await Send(HttpMethod.Post,url,input);return await r.Content.ReadFromJsonAsync<T>();}
 public async Task Post(string url,object input){using var r=await Send(HttpMethod.Post,url,input);}
}
public sealed record Me(string Subject,Guid TenantId,bool IsPatient,bool IsPractitioner,Guid? PatientId,Guid? PractitionerId);
