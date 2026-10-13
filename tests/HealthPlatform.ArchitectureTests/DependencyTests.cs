using HealthPlatform.Domain.Patient;using HealthPlatform.Application;
namespace HealthPlatform.ArchitectureTests;
public sealed class DependencyTests{
 [Fact]public void DomainOnlyDependsOnKernelAndBcl(){var names=typeof(PatientProfile).Assembly.GetReferencedAssemblies().Select(x=>x.Name!);Assert.All(names,n=>Assert.True(n.StartsWith("System")||n is "netstandard" or "mscorlib" or "HealthPlatform.SharedKernel",n));}
 [Fact]public void ApplicationDoesNotDependOnAdapters(){var names=typeof(GetPatient).Assembly.GetReferencedAssemblies().Select(x=>x.Name!);Assert.DoesNotContain(names,n=>n.Contains("Persistence")||n.Contains("Infrastructure")||n.Contains("EntityFramework")||n.Contains("AspNetCore"));}
}
