using HealthPlatform.SharedKernel;
namespace HealthPlatform.Domain.Audit;
public sealed class AuditEntry:AggregateRoot {
 private AuditEntry(){}
 public Guid? PatientId {get;private set;}
 public string Actor {get;private set;}="";
 public string Action {get;private set;}="";
 public string Outcome {get;private set;}="";
 public string CorrelationId {get;private set;}="";
 public string Purpose {get;private set;}="TREATMENT";
 public Guid? GrantId {get;private set;}
 public AuditEntry(Guid tenant,Guid? patient,string actor,string action,string outcome,string correlation,Guid? grant=null){TenantId=tenant;PatientId=patient;Actor=actor;Action=action;Outcome=outcome;CorrelationId=correlation;GrantId=grant;}
}
public sealed class OutboxMessage:AggregateRoot {
 private OutboxMessage(){}
 public string Type {get;private set;}="";
 public string Recipient {get;private set;}="";
 public Guid ReferenceId {get;private set;}
 public DateTime? DeliveredAt {get;set;}
 public OutboxMessage(Guid tenant,string type,string recipient,Guid reference){TenantId=tenant;Type=type;Recipient=recipient;ReferenceId=reference;}
}
