using Microsoft.EntityFrameworkCore;using Microsoft.EntityFrameworkCore.Design;using HealthPlatform.Application;
namespace HealthPlatform.Persistence;
public sealed class DesignTimeFactory:IDesignTimeDbContextFactory<HealthDbContext> {
 public HealthDbContext CreateDbContext(string[] args){var cs=Environment.GetEnvironmentVariable("ConnectionStrings__DefaultConnection")??"server=localhost;port=3306;database=HealthPlatform;user=root;password=";var options=new DbContextOptionsBuilder<HealthDbContext>().UseMySql(cs,new MySqlServerVersion(new Version(8,0,36))).Options;return new(options,new MigrationActor());}
 private sealed class MigrationActor:ICurrentActor {public Guid TenantId=>Guid.Empty;public string Subject=>"migration";public bool IsPatient=>false;public bool IsPractitioner=>false;public bool RecentMfa=>false;public string CorrelationId=>"migration";}
}
