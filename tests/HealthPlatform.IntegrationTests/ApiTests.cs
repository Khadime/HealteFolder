using Microsoft.AspNetCore.Mvc.Testing;using System.Net;
namespace HealthPlatform.IntegrationTests;
public sealed class ApiTests:IClassFixture<WebApplicationFactory<Program>> {
 readonly HttpClient client;public ApiTests(WebApplicationFactory<Program> factory){client=factory.CreateClient();}
 [Theory][InlineData("/api/v1/me")][InlineData("/api/v1/patients/11111111-1111-1111-1111-111111111111")][InlineData("/api/v1/patients/11111111-1111-1111-1111-111111111111/audit-events")]
 public async Task AnonymousCannotRead(string path)=>Assert.Equal(HttpStatusCode.Unauthorized,(await client.GetAsync(path)).StatusCode);
 [Fact]public async Task LivenessIsPublic()=>Assert.Equal(HttpStatusCode.OK,(await client.GetAsync("/health/live")).StatusCode);
}
