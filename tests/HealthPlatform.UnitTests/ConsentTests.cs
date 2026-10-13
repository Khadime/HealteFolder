using HealthPlatform.Domain.Consent;using HealthPlatform.Domain.Patient;using HealthPlatform.Domain.Identity;using HealthPlatform.SharedKernel;using HealthPlatform.Application;using HealthPlatform.Contracts;using HealthPlatform.Infrastructure;using System.Security.Cryptography;
namespace HealthPlatform.UnitTests;
public sealed class ConsentTests {
 readonly Guid tenant=Guid.NewGuid(),patient=Guid.NewGuid();readonly DateTime now=new(2026,1,1,0,0,0,DateTimeKind.Utc);
 AccessRequest Request(int duration=30)=>new(tenant,patient,Guid.NewGuid(),Guid.NewGuid(),Guid.NewGuid(),"professional","Doctor","Clinic",DataScope.Profile,duration,now.AddMinutes(5));
 [Fact] public void ScanDoesNotGrantAccess(){Assert.Equal(RequestStatus.Pending,Request().Status);}
 [Fact] public void DenialCreatesNoGrant(){var r=Request();Assert.Null(r.Decide(false,DataScope.None,0,now));Assert.Equal(RequestStatus.Denied,r.Status);}
 [Fact] public void AcceptCreatesBoundedGrant(){var g=Request().Decide(true,DataScope.Profile,10,now)!;Assert.True(g.Allows(tenant,patient,"professional",DataScope.Profile,now));Assert.False(g.Allows(tenant,patient,"professional",DataScope.Profile,now.AddMinutes(10)));}
 [Fact] public void RevocationBlocksImmediately(){var g=Request().Decide(true,DataScope.Profile,10,now)!;g.Revoke(now.AddSeconds(1));Assert.False(g.Allows(tenant,patient,"professional",DataScope.Profile,now.AddSeconds(1)));}
 [Theory][InlineData(0)][InlineData(31)][InlineData(121)]public void CannotEscalateDuration(int duration)=>Assert.Throws<RuleViolation>(()=>Request().Decide(true,DataScope.Profile,duration,now));
 [Theory][InlineData(DataScope.None)][InlineData(DataScope.Allergies)][InlineData(DataScope.Profile|DataScope.Laboratory)]public void CannotEscalateScope(DataScope scope)=>Assert.Throws<RuleViolation>(()=>Request().Decide(true,scope,10,now));
 [Fact]public void ExpiredRequestCannotBeApproved()=>Assert.Throws<RuleViolation>(()=>Request().Decide(true,DataScope.Profile,10,now.AddMinutes(5)));
 [Fact]public void DecisionIsFinal(){var r=Request();r.Decide(false,DataScope.None,0,now);Assert.Throws<RuleViolation>(()=>r.Decide(true,DataScope.Profile,10,now));}
 [Fact]public void GrantCannotCrossTenantPatientOrSubject(){var g=Request().Decide(true,DataScope.Profile,10,now)!;Assert.False(g.Allows(Guid.NewGuid(),patient,"professional",DataScope.Profile,now));Assert.False(g.Allows(tenant,Guid.NewGuid(),"professional",DataScope.Profile,now));Assert.False(g.Allows(tenant,patient,"other",DataScope.Profile,now));Assert.False(g.Allows(tenant,patient,"professional",DataScope.Profile,now.AddSeconds(-1)));}
 [Fact]public void QrSingleUse(){var q=new QrChallenge(Guid.NewGuid(),tenant,patient,"hash",now.AddMinutes(1),DataScope.Profile);q.Consume(now);Assert.Throws<RuleViolation>(()=>q.Consume(now));}
 [Fact]public void RevokedQrCannotBeConsumed(){var q=new QrChallenge(Guid.NewGuid(),tenant,patient,"hash",now.AddMinutes(1),DataScope.Profile);q.Revoke(now);Assert.Throws<RuleViolation>(()=>q.Consume(now));}
 [Fact]public void ExpiredQrCannotBeConsumed(){var q=new QrChallenge(Guid.NewGuid(),tenant,patient,"hash",now,DataScope.Profile);Assert.Throws<RuleViolation>(()=>q.Consume(now));}
 [Fact]public void LicenseExpiryIsExclusive(){var p=new Practitioner(tenant,"pro","Doctor",Guid.NewGuid(),now,true);Assert.False(p.CanPractice(now));}
 [Fact]public void UnverifiedProfessionalCannotPractice(){var p=new Practitioner(tenant,"pro","Doctor",Guid.NewGuid(),now.AddDays(1),false);Assert.False(p.CanPractice(now));}
 [Fact]public void EmptyPatientIdentityIsRejected()=>Assert.Throws<RuleViolation>(()=>new PatientProfile(tenant,"",new("A","B"),new(2000,1,1)));
 [Fact]public void InvalidRegistrationFailsValidation(){var v=new RegisterValidator();Assert.False(v.Validate(new RegisterPatient(new("","",new(3000,1,1)))).IsValid);}
 [Theory][InlineData(0)][InlineData(601)]public void InvalidTtlFailsValidation(int ttl)=>Assert.False(new IssueValidator().Validate(new IssueQr(patient,new(ttl))).IsValid);
 [Fact]public void InvalidScanFailsValidation()=>Assert.False(new ScanValidator().Validate(new ScanQr(new("",8,999))).IsValid);
 [Fact]public void InvalidDecisionFailsValidation()=>Assert.False(new DecisionValidator().Validate(new DecideAccess(Guid.Empty,new(true,8,0))).IsValid);
 [Fact]public void SignVerifyAndRender(){using var key=ECDsa.Create(ECCurve.NamedCurves.nistP256);using var service=new QrCodeService(key.ExportPkcs8PrivateKeyPem(),"test");var id=Guid.NewGuid();var token=service.Sign(id,now.AddMinutes(5));var decoded=service.Validate(token.Payload,now);Assert.Equal(id,decoded.Challenge);Assert.Equal(token.NonceHash,decoded.NonceHash);Assert.DoesNotContain(patient.ToString(),token.Payload);Assert.Contains("svg",service.RenderQr(token.Payload));Assert.Contains("svg",service.RenderBarcode(token.Payload));}
 [Fact]public void TamperingAndWrongKeyRejected(){using var key=ECDsa.Create(ECCurve.NamedCurves.nistP256);using var other=ECDsa.Create(ECCurve.NamedCurves.nistP256);using var service=new QrCodeService(key.ExportPkcs8PrivateKeyPem(),"test");using var wrong=new QrCodeService(other.ExportPkcs8PrivateKeyPem(),"test");var token=service.Sign(Guid.NewGuid(),now.AddMinutes(5));Assert.Throws<RuleViolation>(()=>wrong.Validate(token.Payload,now));Assert.Throws<RuleViolation>(()=>service.Validate(token.Payload.Replace("hp1","hp2"),now));Assert.Throws<RuleViolation>(()=>service.Validate(token.Payload,now.AddMinutes(5)));}
 [Theory][InlineData("")][InlineData("hp1.x.bad.0.bad.bad")][InlineData("a.b")]
 public void MalformedQrRejected(string payload){using var key=ECDsa.Create(ECCurve.NamedCurves.nistP256);using var service=new QrCodeService(key.ExportPkcs8PrivateKeyPem(),"test");Assert.Throws<RuleViolation>(()=>service.Validate(payload,now));}
}
