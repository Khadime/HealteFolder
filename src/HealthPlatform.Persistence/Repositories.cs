using Microsoft.EntityFrameworkCore;using HealthPlatform.Application;using HealthPlatform.Domain.Patient;using HealthPlatform.Domain.Identity;using HealthPlatform.Domain.Consent;using HealthPlatform.Domain.Audit;using HealthPlatform.SharedKernel;
namespace HealthPlatform.Persistence;
public sealed class HealthRepository(HealthDbContext db):IHealthRepository {
 public Task<PatientProfile?> Patient(Guid id,CancellationToken ct)=>db.Patients.SingleOrDefaultAsync(x=>x.Id==id,ct);
 public Task<PatientProfile?> MyPatient(string subject,CancellationToken ct)=>db.Patients.SingleOrDefaultAsync(x=>x.Subject==subject,ct);
 public Task<Practitioner?> Practitioner(string subject,CancellationToken ct)=>db.Practitioners.SingleOrDefaultAsync(x=>x.Subject==subject,ct);
 public Task<Organization?> Organization(Guid id,CancellationToken ct)=>db.Organizations.SingleOrDefaultAsync(x=>x.Id==id,ct);
 public Task<AccessRequest?> Request(Guid id,CancellationToken ct)=>db.Requests.SingleOrDefaultAsync(x=>x.Id==id,ct);
 public Task<AccessGrant?> Grant(Guid id,CancellationToken ct)=>db.Grants.SingleOrDefaultAsync(x=>x.Id==id,ct);
 public async Task<IReadOnlyList<AccessRequest>> Requests(Guid patient,CancellationToken ct)=>await db.Requests.Where(x=>x.PatientId==patient).OrderByDescending(x=>x.CreatedAt).Take(200).ToListAsync(ct);
 public async Task<IReadOnlyList<AccessGrant>> Grants(Guid patient,CancellationToken ct)=>await db.Grants.Where(x=>x.PatientId==patient).OrderByDescending(x=>x.CreatedAt).Take(200).ToListAsync(ct);
 public async Task<IReadOnlyList<AuditEntry>> Audit(Guid patient,CancellationToken ct)=>await db.Audit.Where(x=>x.PatientId==patient).OrderByDescending(x=>x.CreatedAt).Take(200).ToListAsync(ct);
 public void Add<T>(T entity)where T:AggregateRoot=>db.Add(entity);
 public async Task Save(CancellationToken ct)=>await db.SaveChangesAsync(ct);
}
public sealed class QrChallengeRepository(HealthDbContext db):IQrChallengeRepository {public Task<QrChallenge?> Find(Guid id,CancellationToken ct)=>db.Challenges.SingleOrDefaultAsync(x=>x.Id==id,ct);}
public sealed class Repository<T>(HealthDbContext db):IRepository<T> where T:AggregateRoot {public Task<T?> Get(Guid id,CancellationToken ct)=>db.Set<T>().SingleOrDefaultAsync(x=>x.Id==id,ct);public void Add(T entity)=>db.Add(entity);}
