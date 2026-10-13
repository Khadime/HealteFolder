using Microsoft.AspNetCore.DataProtection;
using MassTransit;using HealthPlatform.Api;using HealthPlatform.Application;using HealthPlatform.Contracts;using HealthPlatform.Persistence;using HealthPlatform.Infrastructure;using HealthPlatform.Domain.Audit;using HealthPlatform.SharedKernel;
using Microsoft.AspNetCore.Authentication.JwtBearer;using Microsoft.EntityFrameworkCore;using Microsoft.AspNetCore.SignalR;using Microsoft.AspNetCore.RateLimiting;using System.Threading.RateLimiting;using FluentValidation;using MediatR;using Serilog;using OpenTelemetry.Trace;using OpenTelemetry.Resources;
var builder=WebApplication.CreateBuilder(args);
// Development keys remain inside the ignored project secrets directory.
// Production uses the deployment's protected, persistent key ring configuration.
if (builder.Environment.IsDevelopment())
{
    var keyDirectory = builder.Configuration["DataProtection:KeyDirectory"]
        ?? Path.GetFullPath(Path.Combine(builder.Environment.ContentRootPath, "..", "..", ".secrets", "data-protection", "Api"));
    builder.Services.AddDataProtection().SetApplicationName("HealthPlatform.Api")
        .PersistKeysToFileSystem(new DirectoryInfo(keyDirectory));
}
builder.Host.UseSerilog((ctx,log)=>log.MinimumLevel.Warning().WriteTo.Console());
builder.Services.AddSingleton(TimeProvider.System);builder.Services.AddHttpContextAccessor();builder.Services.AddScoped<ICurrentActor,CurrentActor>();
builder.Services.AddDbContext<HealthDbContext>(o=>o.UseMySql(builder.Configuration.GetConnectionString("DefaultConnection"),new MySqlServerVersion(new Version(8,0,36))));
builder.Services.AddScoped<IHealthRepository,HealthRepository>();builder.Services.AddScoped<IQrChallengeRepository,QrChallengeRepository>();builder.Services.AddScoped<AccessService>();
builder.Services.AddAutoMapper(cfg=>{cfg.LicenseKey=builder.Configuration["AutoMapper:LicenseKey"];},typeof(PatientMapping));
builder.Services.AddMediatR(c=>c.RegisterServicesFromAssemblyContaining<RegisterPatient>());builder.Services.AddValidatorsFromAssemblyContaining<RegisterValidator>();builder.Services.AddTransient(typeof(IPipelineBehavior<,>),typeof(ValidationBehavior<,>));
builder.Services.AddSingleton(sp=>new QrCodeService(File.ReadAllText(builder.Configuration["Qr:PrivateKeyPath"]??throw new InvalidOperationException("Configure Qr:PrivateKeyPath")),builder.Configuration["Qr:KeyId"]??"dev-1"));
builder.Services.AddSingleton<IQrCodeService>(sp=>sp.GetRequiredService<QrCodeService>());builder.Services.AddSingleton<IQrValidationService>(sp=>sp.GetRequiredService<QrCodeService>());
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(o=>{o.Authority=builder.Configuration["Authentication:Authority"];o.Audience="health-api";o.MapInboundClaims=false;o.RequireHttpsMetadata=!builder.Environment.IsDevelopment();o.TokenValidationParameters.RoleClaimType="role";o.TokenValidationParameters.NameClaimType="sub";o.TokenValidationParameters.ClockSkew=TimeSpan.FromSeconds(15);});
builder.Services.AddAuthorization(o=>o.AddPolicy("clinical",p=>p.RequireAuthenticatedUser().RequireAssertion(ctx=>Guid.TryParse(ctx.User.FindFirst("tenant_id")?.Value,out var id)&&id!=Guid.Empty&&!string.IsNullOrEmpty(ctx.User.FindFirst("sub")?.Value)&&ctx.User.FindFirst("acr")?.Value=="2")));
builder.Services.AddRateLimiter(o=>{o.RejectionStatusCode=429;o.AddPolicy("api",ctx=>RateLimitPartition.GetFixedWindowLimiter(ctx.User.FindFirst("sub")?.Value??ctx.Connection.RemoteIpAddress?.ToString()??"unknown",_=>new(){PermitLimit=60,Window=TimeSpan.FromMinutes(1),QueueLimit=0}));});
builder.Services.AddSignalR();builder.Services.AddOpenApi();builder.Services.AddProblemDetails();
builder.Services.AddOpenTelemetry().ConfigureResource(r=>r.AddService("HealthPlatform.Api")).WithTracing(t=>t.AddAspNetCoreInstrumentation(o=>o.Filter=ctx=>!ctx.Request.Path.StartsWithSegments("/api")).AddOtlpExporter());
if(builder.Configuration.GetValue<bool>("RabbitMq:Enabled"))builder.Services.AddMassTransit(x=>{x.AddConsumer<NotificationConsumer>();x.UsingRabbitMq((ctx,cfg)=>{cfg.Host(builder.Configuration["RabbitMq:Host"]??"localhost","/",h=>{h.Username("health");h.Password(builder.Configuration["RabbitMq:Password"]??throw new InvalidOperationException("Set RabbitMq:Password"));});cfg.ReceiveEndpoint("health-api-notifications",e=>e.ConfigureConsumer<NotificationConsumer>(ctx));});});
var app=builder.Build();
app.Use(async(ctx,next)=>{ctx.TraceIdentifier=Guid.NewGuid().ToString("N");ctx.Response.Headers["X-Correlation-Id"]=ctx.TraceIdentifier;ctx.Response.Headers.CacheControl="no-store";ctx.Response.Headers["X-Content-Type-Options"]="nosniff";await next();});
app.UseAuthentication();app.UseAuthorization();app.UseRateLimiter();
app.Use(async(ctx,next)=>{try{await next();}catch(Exception e)when(e is AccessDenied or RuleViolation or ValidationException or DbUpdateException){var status=e is AccessDenied?403:e is ValidationException?400:409;
 var actor=ctx.RequestServices.GetRequiredService<ICurrentActor>();var db=ctx.RequestServices.GetRequiredService<HealthDbContext>();db.ChangeTracker.Clear();
 if(actor.TenantId!=Guid.Empty){db.Audit.Add(new AuditEntry(actor.TenantId,null,actor.Subject,"request.denied","deny",actor.CorrelationId));await db.SaveChangesAsync(ctx.RequestAborted);}
 await Results.Problem(statusCode:status,title:status==403?"Accès refusé":status==400?"Requête invalide":"Conflit ou ressource expirée",extensions:new Dictionary<string,object?>{{"traceId",ctx.TraceIdentifier}}).ExecuteAsync(ctx);
 }});
if(app.Environment.IsDevelopment())app.MapOpenApi();
app.MapGet("/health/live",()=>Results.Ok(new{status="live"}));
app.MapGet("/health/ready",async(HealthDbContext db,CancellationToken ct)=>await db.Database.CanConnectAsync(ct)?Results.Ok():Results.StatusCode(503));
var api=app.MapGroup("/api/v1").RequireAuthorization("clinical").RequireRateLimiting("api");
api.MapGet("/me",async(ICurrentActor actor,IHealthRepository db,CancellationToken ct)=>new{actor.Subject,actor.TenantId,actor.IsPatient,actor.IsPractitioner,patientId=(await db.MyPatient(actor.Subject,ct))?.Id,practitionerId=(await db.Practitioner(actor.Subject,ct))?.Id});
api.MapPost("/patients",async(RegisterPatientDto input,ISender sender,CancellationToken ct)=>Results.Ok(await sender.Send(new RegisterPatient(input),ct)));
api.MapPost("/practitioners",async(RegisterPractitionerDto input,ISender sender,CancellationToken ct)=>Results.Ok(await sender.Send(new RegisterPractitioner(input),ct)));
api.MapGet("/patients/{id:guid}",async(Guid id,ISender sender,CancellationToken ct)=>await sender.Send(new GetPatient(id),ct));
api.MapPost("/patients/{id:guid}/access-codes",async(Guid id,IssueQrDto input,ISender sender,CancellationToken ct)=>Results.Ok(await sender.Send(new IssueQr(id,input),ct)));
api.MapPost("/access-codes/scan",async(ScanQrDto input,ISender sender,CancellationToken ct)=>Results.Accepted(value:new{accessRequestId=await sender.Send(new ScanQr(input),ct)}));
api.MapGet("/patients/{id:guid}/access-requests",async(Guid id,ISender sender,CancellationToken ct)=>await sender.Send(new ListRequests(id),ct));
api.MapPost("/access-requests/{id:guid}/decisions",async(Guid id,DecisionDto input,ISender sender,CancellationToken ct)=>await sender.Send(new DecideAccess(id,input),ct));
api.MapGet("/patients/{id:guid}/access-grants",async(Guid id,ISender sender,CancellationToken ct)=>await sender.Send(new ListGrants(id),ct));
api.MapPost("/consents/{id:guid}/revoke",async(Guid id,ISender sender,CancellationToken ct)=>{await sender.Send(new RevokeGrant(id),ct);return Results.NoContent();});
api.MapGet("/patients/{id:guid}/audit-events",async(Guid id,ISender sender,CancellationToken ct)=>await sender.Send(new ListAudit(id),ct));
app.MapHub<AccessHub>("/hubs/access").RequireAuthorization("clinical");
app.Run();
public partial class Program{}
public sealed class AccessHub:Hub {public override async Task OnConnectedAsync(){var user=Context.User!;await Groups.AddToGroupAsync(Context.ConnectionId,$"{user.FindFirst("tenant_id")!.Value}:{user.FindFirst("sub")!.Value}");await base.OnConnectedAsync();}}

