using HealthPlatform.Domain.Patient;
using HealthPlatform.Domain.Identity;
using HealthPlatform.Domain.Consent;
using HealthPlatform.Domain.Audit;
namespace HealthPlatform.Application;
public sealed class AccessService(IHealthRepository db,ICurrentActor actor,TimeProvider clock) {
 public async Task<PatientProfile> Owner(Guid patient,CancellationToken ct){var p=await db.Patient(patient,ct);if(p==null||!actor.IsPatient||p.Subject!=actor.Subject)throw new AccessDenied();return p;}
 public void Mfa(){if(!actor.RecentMfa)throw new AccessDenied();}
 public async Task<Practitioner> Professional(CancellationToken ct){var p=await db.Practitioner(actor.Subject,ct);if(!actor.IsPractitioner||p==null||!p.CanPractice(clock.GetUtcNow().UtcDateTime))throw new AccessDenied();var org=await db.Organization(p.OrganizationId,ct);if(org==null||!org.Active)throw new AccessDenied();return p;}
 public async Task<PatientProfile> Read(Guid patient,CancellationToken ct){
 var p=await db.Patient(patient,ct);if(p==null)throw new AccessDenied();
 if(actor.IsPatient&&p.Subject==actor.Subject){Log(patient,"profile.read","permit");await db.Save(ct);return p;}
 var pro=await Professional(ct);var now=clock.GetUtcNow().UtcDateTime;
 var grant=(await db.Grants(patient,ct)).FirstOrDefault(g=>g.OrganizationId==pro.OrganizationId&&g.PractitionerId==pro.Id&&g.Allows(actor.TenantId,patient,actor.Subject,DataScope.Profile,now));
 if(grant==null)throw new AccessDenied();Log(patient,"profile.read","permit",grant.Id);await db.Save(ct);return p;
 }
 public void Log(Guid? patient,string action,string outcome,Guid? grant=null)=>db.Add(new AuditEntry(actor.TenantId,patient,actor.Subject,action,outcome,actor.CorrelationId,grant));
}
