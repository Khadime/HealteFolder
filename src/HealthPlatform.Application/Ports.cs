using HealthPlatform.Domain.Patient;
using HealthPlatform.Domain.Identity;
using HealthPlatform.Domain.Consent;
using HealthPlatform.Domain.Audit;
using HealthPlatform.SharedKernel;
namespace HealthPlatform.Application;
public interface ICurrentActor { Guid TenantId{get;} string Subject{get;} bool IsPatient{get;} bool IsPractitioner{get;} bool RecentMfa{get;} string CorrelationId{get;} }
public interface IRepository<T> where T:AggregateRoot { Task<T?> Get(Guid id,CancellationToken ct); void Add(T entity); }
public interface IHealthRepository {
 Task<PatientProfile?> Patient(Guid id,CancellationToken ct); Task<PatientProfile?> MyPatient(string subject,CancellationToken ct);
 Task<Practitioner?> Practitioner(string subject,CancellationToken ct); Task<Organization?> Organization(Guid id,CancellationToken ct);
 Task<AccessRequest?> Request(Guid id,CancellationToken ct); Task<AccessGrant?> Grant(Guid id,CancellationToken ct);
 Task<IReadOnlyList<AccessRequest>> Requests(Guid patient,CancellationToken ct); Task<IReadOnlyList<AccessGrant>> Grants(Guid patient,CancellationToken ct);
 Task<IReadOnlyList<AuditEntry>> Audit(Guid patient,CancellationToken ct);
 void Add<T>(T entity) where T:AggregateRoot; Task Save(CancellationToken ct);
}
public interface IQrChallengeRepository {Task<QrChallenge?> Find(Guid id,CancellationToken ct);}
public interface IQrCodeService { (string Payload,string NonceHash) Sign(Guid challenge,DateTime expires); string RenderQr(string payload); string RenderBarcode(string payload); }
public interface IQrValidationService { (Guid Challenge,string NonceHash,DateTime Expires) Validate(string payload,DateTime now); }
public sealed class AccessDenied():Exception("ACCESS_DENIED");
