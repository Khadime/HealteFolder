using HealthPlatform.SharedKernel;
namespace HealthPlatform.Domain.Patient;
public sealed record PatientRegistered(Guid PatientId,DateTime OccurredAt):IDomainEvent;
public sealed record PersonName(string Given,string Family);
public sealed class PatientProfile : AggregateRoot {
 private PatientProfile() { }
 public string Subject {get; private set;}="";
 public string GivenName {get; private set;}="";
 public string FamilyName {get; private set;}="";
 public DateOnly BirthDate {get; private set;}
 public PatientProfile(Guid tenant,string subject,PersonName name,DateOnly birthDate){
  if(tenant==Guid.Empty || string.IsNullOrWhiteSpace(subject) || string.IsNullOrWhiteSpace(name.Given) || string.IsNullOrWhiteSpace(name.Family)) throw new RuleViolation("INVALID_PATIENT");
  TenantId=tenant;Subject=subject;GivenName=name.Given;FamilyName=name.Family;BirthDate=birthDate;
 }
}
public sealed class PatientOwner(string subject):ISpecification<PatientProfile>{public bool IsSatisfiedBy(PatientProfile p)=>p.Subject==subject;}
