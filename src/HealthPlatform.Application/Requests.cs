using MediatR;
using FluentValidation;
using HealthPlatform.Contracts;
using HealthPlatform.Domain.Patient;
using HealthPlatform.Domain.Identity;
using HealthPlatform.Domain.Consent;
using HealthPlatform.Domain.Audit;
using HealthPlatform.SharedKernel;
namespace HealthPlatform.Application;
public sealed record RegisterPatient(RegisterPatientDto Input):IRequest<PatientDto>;
public sealed record RegisterPractitioner(RegisterPractitionerDto Input):IRequest<PractitionerDto>;
public sealed record GetPatient(Guid Id):IRequest<PatientDto>;
public sealed record IssueQr(Guid PatientId,IssueQrDto Input):IRequest<QrDto>;
public sealed record ScanQr(ScanQrDto Input):IRequest<Guid>;
public sealed record DecideAccess(Guid Id,DecisionDto Input):IRequest<DecisionResult>;
public sealed record RevokeGrant(Guid Id):IRequest;
public sealed record ListRequests(Guid PatientId):IRequest<IReadOnlyList<AccessRequestDto>>;
public sealed record ListGrants(Guid PatientId):IRequest<IReadOnlyList<GrantDto>>;
public sealed record ListAudit(Guid PatientId):IRequest<IReadOnlyList<AuditDto>>;
public sealed class RegisterValidator:AbstractValidator<RegisterPatient>{public RegisterValidator(){RuleFor(x=>x.Input.GivenName).NotEmpty().MaximumLength(100);RuleFor(x=>x.Input.FamilyName).NotEmpty().MaximumLength(100);RuleFor(x=>x.Input.BirthDate).LessThanOrEqualTo(_=>DateOnly.FromDateTime(DateTime.UtcNow)).GreaterThan(new DateOnly(1850,1,1));}}
public sealed class RegisterPractitionerValidator:AbstractValidator<RegisterPractitioner>{public RegisterPractitionerValidator(){RuleFor(x=>x.Input.DisplayName).NotEmpty().MaximumLength(150);RuleFor(x=>x.Input.OrganizationName).NotEmpty().MaximumLength(180);RuleFor(x=>x.Input.Jurisdiction).NotEmpty().MaximumLength(100);RuleFor(x=>x.Input.LicenseExpiresOn).GreaterThan(_=>DateOnly.FromDateTime(DateTime.UtcNow)).LessThan(_=>DateOnly.FromDateTime(DateTime.UtcNow.AddYears(15)));}}
public sealed class IssueValidator:AbstractValidator<IssueQr>{public IssueValidator(){RuleFor(x=>x.PatientId).NotEmpty();RuleFor(x=>x.Input.TtlSeconds).InclusiveBetween(30,600);RuleFor(x=>x.Input.Scope).Equal(1);}}
public sealed class ScanValidator:AbstractValidator<ScanQr>{public ScanValidator(){RuleFor(x=>x.Input.QrPayload).NotEmpty().MaximumLength(2048);RuleFor(x=>x.Input.Scope).Equal(1);RuleFor(x=>x.Input.DurationMinutes).InclusiveBetween(1,120);}}
public sealed class DecisionValidator:AbstractValidator<DecideAccess>{public DecisionValidator(){RuleFor(x=>x.Id).NotEmpty();When(x=>x.Input.Accept,()=>{RuleFor(x=>x.Input.Scope).Equal(1);RuleFor(x=>x.Input.DurationMinutes).InclusiveBetween(1,120);});}}
public sealed class Handlers(IHealthRepository db,IQrChallengeRepository challenges,ICurrentActor actor,AccessService access,IQrCodeService qr,IQrValidationService validation,TimeProvider clock,AutoMapper.IMapper mapper):
 IRequestHandler<RegisterPatient,PatientDto>,IRequestHandler<RegisterPractitioner,PractitionerDto>,IRequestHandler<GetPatient,PatientDto>,IRequestHandler<IssueQr,QrDto>,IRequestHandler<ScanQr,Guid>,IRequestHandler<DecideAccess,DecisionResult>,IRequestHandler<RevokeGrant>,IRequestHandler<ListRequests,IReadOnlyList<AccessRequestDto>>,IRequestHandler<ListGrants,IReadOnlyList<GrantDto>>,IRequestHandler<ListAudit,IReadOnlyList<AuditDto>> {
 PatientDto Map(PatientProfile p)=>mapper.Map<PatientDto>(p);
 public async Task<PatientDto> Handle(RegisterPatient r,CancellationToken ct){if(!actor.IsPatient)throw new AccessDenied();access.Mfa();if(await db.MyPatient(actor.Subject,ct)!=null)throw new RuleViolation("PROFILE_EXISTS");var p=new PatientProfile(actor.TenantId,actor.Subject,new(r.Input.GivenName,r.Input.FamilyName),r.Input.BirthDate);db.Add(p);access.Log(p.Id,"patient.register","permit");await db.Save(ct);return Map(p);}
 public async Task<PractitionerDto> Handle(RegisterPractitioner r,CancellationToken ct){
  if(!actor.IsPractitioner)throw new AccessDenied();access.Mfa();if(await db.Practitioner(actor.Subject,ct)!=null)throw new RuleViolation("PROFILE_EXISTS");
  var organization=new Organization(actor.TenantId,r.Input.OrganizationName.Trim(),r.Input.Jurisdiction.Trim());
  var licenseUntil=r.Input.LicenseExpiresOn.ToDateTime(TimeOnly.MaxValue,DateTimeKind.Utc);
  var practitioner=new Practitioner(actor.TenantId,actor.Subject,r.Input.DisplayName.Trim(),organization.Id,licenseUntil,false);
  db.Add(organization);db.Add(practitioner);access.Log(null,"practitioner.register","permit");await db.Save(ct);
  return new(practitioner.Id,practitioner.DisplayName,organization.Id,organization.Name,r.Input.LicenseExpiresOn,practitioner.Verified,practitioner.Version);
 }
 public async Task<PatientDto> Handle(GetPatient r,CancellationToken ct)=>Map(await access.Read(r.Id,ct));
 public async Task<QrDto> Handle(IssueQr r,CancellationToken ct){await access.Owner(r.PatientId,ct);access.Mfa();var expiry=clock.GetUtcNow().UtcDateTime.AddSeconds(r.Input.TtlSeconds);var id=Guid.CreateVersion7();var signed=qr.Sign(id,expiry);var challenge=new QrChallenge(id,actor.TenantId,r.PatientId,signed.NonceHash,expiry,(DataScope)r.Input.Scope);
 db.Add(challenge);access.Log(r.PatientId,"qr.issue","permit");await db.Save(ct);return new(challenge.Id,signed.Payload,expiry,qr.RenderQr(signed.Payload),qr.RenderBarcode(signed.Payload));}
 public async Task<Guid> Handle(ScanQr r,CancellationToken ct){access.Mfa();var pro=await access.Professional(ct);var now=clock.GetUtcNow().UtcDateTime;var token=validation.Validate(r.Input.QrPayload,now);var challenge=await challenges.Find(token.Challenge,ct)??throw new RuleViolation("INVALID_QR");if(challenge.NonceHash!=token.NonceHash||Math.Abs((challenge.ExpiresAt-token.Expires).TotalSeconds)>1||!ScopePolicy.Includes(challenge.Scope,(DataScope)r.Input.Scope))throw new RuleViolation("INVALID_QR");challenge.Consume(now);var org=await db.Organization(pro.OrganizationId,ct)??throw new AccessDenied();var patient=await db.Patient(challenge.PatientId,ct)??throw new AccessDenied();var request=new AccessRequest(actor.TenantId,patient.Id,challenge.Id,pro.Id,org.Id,pro.Subject,pro.DisplayName,org.Name,(DataScope)r.Input.Scope,r.Input.DurationMinutes,challenge.ExpiresAt);db.Add(request);db.Add(new OutboxMessage(actor.TenantId,"access.requested.v1",patient.Subject,request.Id));access.Log(patient.Id,"qr.scan","permit");await db.Save(ct);return request.Id;}
 public async Task<DecisionResult> Handle(DecideAccess r,CancellationToken ct){access.Mfa();var request=await db.Request(r.Id,ct)??throw new AccessDenied();await access.Owner(request.PatientId,ct);var grant=request.Decide(r.Input.Accept,(DataScope)r.Input.Scope,r.Input.DurationMinutes,clock.GetUtcNow().UtcDateTime);if(grant!=null)db.Add(grant);db.Add(new OutboxMessage(actor.TenantId,"access.decided.v1",request.PractitionerSubject,request.Id));access.Log(request.PatientId,"access.decision",r.Input.Accept?"grant":"deny",grant?.Id);await db.Save(ct);return new(request.Id,grant?.Id);}
 public async Task Handle(RevokeGrant r,CancellationToken ct){access.Mfa();var grant=await db.Grant(r.Id,ct)??throw new AccessDenied();await access.Owner(grant.PatientId,ct);grant.Revoke(clock.GetUtcNow().UtcDateTime);db.Add(new OutboxMessage(actor.TenantId,"access.revoked.v1",grant.Subject,grant.Id));access.Log(grant.PatientId,"access.revoke","permit",grant.Id);await db.Save(ct);}
 public async Task<IReadOnlyList<AccessRequestDto>> Handle(ListRequests r,CancellationToken ct){await access.Owner(r.PatientId,ct);return (await db.Requests(r.PatientId,ct)).Select(x=>new AccessRequestDto(x.Id,x.PractitionerName,x.OrganizationName,x.Purpose,(int)x.Scope,x.DurationMinutes,x.ExpiresAt,x.Status.ToString())).ToList();}
 public async Task<IReadOnlyList<GrantDto>> Handle(ListGrants r,CancellationToken ct){await access.Owner(r.PatientId,ct);return (await db.Grants(r.PatientId,ct)).Select(x=>new GrantDto(x.Id,x.PatientId,(int)x.Scope,x.ValidUntil,x.RevokedAt)).ToList();}
 public async Task<IReadOnlyList<AuditDto>> Handle(ListAudit r,CancellationToken ct){await access.Owner(r.PatientId,ct);access.Log(r.PatientId,"audit.read","permit");await db.Save(ct);return (await db.Audit(r.PatientId,ct)).Select(x=>new AuditDto(x.Id,x.CreatedAt,x.Actor,x.Action,x.Outcome,x.Purpose,x.GrantId)).ToList();}
}
