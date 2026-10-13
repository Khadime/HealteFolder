using HealthPlatform.SharedKernel;
namespace HealthPlatform.Domain.Identity;
public sealed class UserAccount : AggregateRoot {
 private UserAccount() { }
 public string Subject {get; private set;} = "";
 public bool Active {get; private set;} = true;
 public UserAccount(Guid tenant,string subject) {TenantId=tenant;Subject=subject;}
}
public sealed class Organization : AggregateRoot {
 private Organization() { }
 public string Name {get; private set;} = "";
 public string Jurisdiction {get; private set;} = "";
 public bool Active {get; private set;}=true;
 public Organization(Guid tenant,string name,string jurisdiction){TenantId=tenant;Name=name;Jurisdiction=jurisdiction;}
}
public sealed class Practitioner : AggregateRoot {
 private Practitioner() { }
 public string Subject {get; private set;}="";
 public string DisplayName {get; private set;}="";
 public Guid OrganizationId {get; private set;}
 public DateTime LicenseUntil {get; private set;}
 public bool Verified {get; private set;}
 public Practitioner(Guid tenant,string subject,string name,Guid organization,DateTime licenseUntil,bool verified){TenantId=tenant;Subject=subject;DisplayName=name;OrganizationId=organization;LicenseUntil=licenseUntil;Verified=verified;}
 public bool CanPractice(DateTime now)=>Verified && LicenseUntil>now;
}
