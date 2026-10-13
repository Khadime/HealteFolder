using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using HealthPlatform.Application;
using HealthPlatform.Domain.Patient;
using HealthPlatform.Domain.Identity;
using HealthPlatform.Domain.Consent;
using HealthPlatform.Domain.Audit;
using HealthPlatform.SharedKernel;
namespace HealthPlatform.Persistence;
public sealed class HealthDbContext(DbContextOptions<HealthDbContext> options,ICurrentActor actor):DbContext(options) {
 public Guid CurrentTenant=>actor.TenantId;
 public DbSet<PatientProfile> Patients=>Set<PatientProfile>(); public DbSet<Practitioner> Practitioners=>Set<Practitioner>();
 public DbSet<Organization> Organizations=>Set<Organization>(); public DbSet<UserAccount> Accounts=>Set<UserAccount>();
 public DbSet<QrChallenge> Challenges=>Set<QrChallenge>();public DbSet<AccessRequest> Requests=>Set<AccessRequest>();public DbSet<AccessGrant> Grants=>Set<AccessGrant>();public DbSet<AuditEntry> Audit=>Set<AuditEntry>();public DbSet<OutboxMessage> Outbox=>Set<OutboxMessage>();
 void Common<T>(EntityTypeBuilder<T> b,string table) where T:AggregateRoot {
 b.ToTable(table);b.HasKey(x=>new{x.TenantId,x.Id});b.Property(x=>x.Version).IsConcurrencyToken();b.HasQueryFilter(x=>x.TenantId==CurrentTenant);
 b.Property(x=>x.CreatedAt).HasColumnType("datetime(6)");
 }
 protected override void OnModelCreating(ModelBuilder m){
 Common(m.Entity<PatientProfile>(),"patient_profile");Common(m.Entity<UserAccount>(),"identity_account");Common(m.Entity<Organization>(),"organization");Common(m.Entity<Practitioner>(),"practitioner");Common(m.Entity<QrChallenge>(),"consent_qr_challenge");Common(m.Entity<AccessRequest>(),"consent_access_request");Common(m.Entity<AccessGrant>(),"consent_access_grant");Common(m.Entity<AuditEntry>(),"audit_event");Common(m.Entity<OutboxMessage>(),"outbox_message");
 foreach(var t in m.Model.GetEntityTypes())foreach(var p in t.GetProperties()){
 if(p.ClrType==typeof(string))p.SetMaxLength(200);
 if(p.ClrType==typeof(DateTime)||p.ClrType==typeof(DateTime?))p.SetColumnType("datetime(6)");
 }
 m.Entity<PatientProfile>().HasIndex(x=>new{x.TenantId,x.Subject}).IsUnique();
 m.Entity<UserAccount>().HasIndex(x=>new{x.TenantId,x.Subject}).IsUnique();
 m.Entity<Practitioner>().HasIndex(x=>new{x.TenantId,x.Subject}).IsUnique();
 m.Entity<Practitioner>().HasOne<Organization>().WithMany().HasForeignKey(x=>new{x.TenantId,x.OrganizationId}).OnDelete(DeleteBehavior.Restrict);
 m.Entity<QrChallenge>().HasIndex(x=>new{x.TenantId,x.NonceHash}).IsUnique();
 m.Entity<QrChallenge>().HasOne<PatientProfile>().WithMany().HasForeignKey(x=>new{x.TenantId,x.PatientId}).OnDelete(DeleteBehavior.Restrict);
 m.Entity<AccessRequest>().HasIndex(x=>new{x.TenantId,x.ChallengeId}).IsUnique();
 m.Entity<AccessRequest>().HasOne<QrChallenge>().WithMany().HasForeignKey(x=>new{x.TenantId,x.ChallengeId}).OnDelete(DeleteBehavior.Restrict);
 m.Entity<AccessRequest>().HasOne<PatientProfile>().WithMany().HasForeignKey(x=>new{x.TenantId,x.PatientId}).OnDelete(DeleteBehavior.Restrict);
 m.Entity<AccessRequest>().HasOne<Practitioner>().WithMany().HasForeignKey(x=>new{x.TenantId,x.PractitionerId}).OnDelete(DeleteBehavior.Restrict);
 m.Entity<AccessRequest>().HasIndex(x=>new{x.TenantId,x.PatientId,x.Status,x.CreatedAt});
 m.Entity<AccessGrant>().HasOne<AccessRequest>().WithMany().HasForeignKey(x=>new{x.TenantId,x.RequestId}).OnDelete(DeleteBehavior.Restrict);
 m.Entity<AccessGrant>().HasIndex(x=>new{x.TenantId,x.RequestId}).IsUnique();
 m.Entity<AccessGrant>().HasIndex(x=>new{x.TenantId,x.PatientId,x.Subject,x.ValidUntil});
 m.Entity<AuditEntry>().HasIndex(x=>new{x.TenantId,x.PatientId,x.CreatedAt});
 m.Entity<OutboxMessage>().HasIndex(x=>new{x.TenantId,x.DeliveredAt,x.CreatedAt});
 }
 public override Task<int> SaveChangesAsync(CancellationToken ct=default){
 foreach(var e in ChangeTracker.Entries<AggregateRoot>()){
 if(e.State is EntityState.Added or EntityState.Modified or EntityState.Deleted){
 if(e.Entity.TenantId!=CurrentTenant||CurrentTenant==Guid.Empty)throw new AccessDenied();
 if(e.Entity is AuditEntry && e.State!=EntityState.Added)throw new InvalidOperationException("Audit is append-only");
 if(e.State==EntityState.Modified)e.Entity.Version++;
 }}return base.SaveChangesAsync(ct);
 }
}
