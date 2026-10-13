using HealthPlatform.SharedKernel;
namespace HealthPlatform.Domain.Consent;
[Flags] public enum DataScope { None=0, Profile=1, Allergies=2, Medication=4, Laboratory=8, Documents=16 }
public enum RequestStatus { Pending,Granted,Denied }
public sealed record AccessDecided(Guid RequestId,bool Granted,DateTime OccurredAt):IDomainEvent;
public static class ScopePolicy {
 public const DataScope Supported=DataScope.Profile;
 public static void Validate(DataScope scope){if(scope==DataScope.None || (scope & ~Supported)!=0)throw new RuleViolation("UNSUPPORTED_SCOPE");}
 public static bool Includes(DataScope allowed,DataScope requested)=>requested!=DataScope.None && (allowed & requested)==requested;
}
public sealed class QrChallenge:AggregateRoot {
 private QrChallenge(){}
 public Guid PatientId {get; private set;}
 public string NonceHash {get; private set;}="";
 public DateTime ExpiresAt {get; private set;}
 public DateTime? ConsumedAt {get; private set;}
 public DateTime? RevokedAt {get; private set;}
 public DataScope Scope {get; private set;}
 public QrChallenge(Guid id,Guid tenant,Guid patient,string hash,DateTime expires,DataScope scope){ScopePolicy.Validate(scope);Id=id;TenantId=tenant;PatientId=patient;NonceHash=hash;ExpiresAt=expires;Scope=scope;}
 public void Consume(DateTime now){if(ExpiresAt<=now || ConsumedAt!=null || RevokedAt!=null)throw new RuleViolation("INVALID_QR");ConsumedAt=now;}
 public void Revoke(DateTime now)=>RevokedAt=now;
}
public sealed class AccessRequest:AggregateRoot {
 private AccessRequest(){}
 public Guid PatientId {get;private set;}
 public Guid PractitionerId {get;private set;}
 public Guid OrganizationId {get;private set;}
 public string PractitionerSubject {get;private set;}="";
 public string PractitionerName {get;private set;}="";
 public string OrganizationName {get;private set;}="";
 public string Purpose {get;private set;}="TREATMENT";
 public Guid ChallengeId {get;private set;}
 public DataScope Scope {get;private set;}
 public int DurationMinutes {get;private set;}
 public DateTime ExpiresAt {get;private set;}
 public RequestStatus Status {get;private set;}
 public AccessRequest(Guid tenant,Guid patient,Guid challenge,Guid practitioner,Guid organization,string subject,string name,string orgName,DataScope scope,int duration,DateTime expires){
 ScopePolicy.Validate(scope);if(duration is <1 or >120)throw new RuleViolation("INVALID_DURATION");TenantId=tenant;PatientId=patient;ChallengeId=challenge;PractitionerId=practitioner;OrganizationId=organization;PractitionerSubject=subject;PractitionerName=name;OrganizationName=orgName;Scope=scope;DurationMinutes=duration;ExpiresAt=expires;}
 public AccessGrant? Decide(bool accept,DataScope scope,int minutes,DateTime now){
 if(Status!=RequestStatus.Pending || ExpiresAt<=now)throw new RuleViolation("REQUEST_CLOSED");
 if(!accept){Status=RequestStatus.Denied;return null;}
 if(!ScopePolicy.Includes(Scope,scope)||minutes<1||minutes>DurationMinutes)throw new RuleViolation("SCOPE_ESCALATION");
 Status=RequestStatus.Granted;return new AccessGrant(TenantId,PatientId,Id,PractitionerId,OrganizationId,PractitionerSubject,scope,now,now.AddMinutes(minutes));}
}
public sealed class AccessGrant:AggregateRoot {
 private AccessGrant(){}
 public Guid PatientId {get;private set;}
 public Guid RequestId {get;private set;}
 public Guid PractitionerId {get;private set;}
 public Guid OrganizationId {get;private set;}
 public string Subject {get;private set;}="";
 public string Purpose {get;private set;}="TREATMENT";
 public DataScope Scope {get;private set;}
 public DateTime ValidFrom {get;private set;}
 public DateTime ValidUntil {get;private set;}
 public DateTime? RevokedAt {get;private set;}
 internal AccessGrant(Guid tenant,Guid patient,Guid request,Guid practitioner,Guid org,string subject,DataScope scope,DateTime from,DateTime until){TenantId=tenant;PatientId=patient;RequestId=request;PractitionerId=practitioner;OrganizationId=org;Subject=subject;Scope=scope;ValidFrom=from;ValidUntil=until;}
 public bool Allows(Guid tenant,Guid patient,string subject,DataScope scope,DateTime now)=>TenantId==tenant&&PatientId==patient&&Subject==subject&&RevokedAt==null&&new DateWindow(ValidFrom,ValidUntil).Contains(now)&&ScopePolicy.Includes(Scope,scope);
 public void Revoke(DateTime now){RevokedAt??=now;}
}
public sealed class ActiveGrant(DateTime now):ISpecification<AccessGrant>{public bool IsSatisfiedBy(AccessGrant grant)=>grant.RevokedAt==null&&new DateWindow(grant.ValidFrom,grant.ValidUntil).Contains(now);}
