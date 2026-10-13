namespace HealthPlatform.SharedKernel;
public interface IDomainEvent { DateTime OccurredAt { get; } }
public abstract class AggregateRoot {
 public Guid Id {get; protected set;} = Guid.CreateVersion7();
 public Guid TenantId {get; protected set;}
 public long Version {get; set;} = 1;
 public DateTime CreatedAt {get; protected set;} = DateTime.UtcNow;
}
public sealed class RuleViolation(string code) : Exception(code) { public string Code => Message; }
public interface ISpecification<in T> { bool IsSatisfiedBy(T value); }
public sealed record DateWindow(DateTime From, DateTime Until) {
 public bool Contains(DateTime now) => From <= now && now < Until;
}
