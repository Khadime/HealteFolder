using MassTransit;using Microsoft.AspNetCore.SignalR;using HealthPlatform.Contracts;
namespace HealthPlatform.Api;
/// <summary>Notifications invalidate the UI; the persisted API state remains authoritative.</summary>
public sealed class NotificationConsumer(IHubContext<AccessHub> hub):IConsumer<ProfileNotification> {
 public Task Consume(ConsumeContext<ProfileNotification> ctx)=>hub.Clients.Group($"{ctx.Message.TenantId}:{ctx.Message.Recipient}").SendAsync("AccessChanged",new{ctx.Message.EventId,ctx.Message.ReferenceId},ctx.CancellationToken);
}
