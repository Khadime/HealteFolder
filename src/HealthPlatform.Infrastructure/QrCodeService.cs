using System.Security.Cryptography;using System.Text;using System.Globalization;using HealthPlatform.Application;using HealthPlatform.SharedKernel;using QRCoder;using ZXing;using ZXing.Common;using ZXing.Rendering;
namespace HealthPlatform.Infrastructure;
public sealed class QrCodeService:IQrCodeService,IQrValidationService,IDisposable {
 private readonly ECDsa key;private readonly string kid;private readonly object gate=new();
 public QrCodeService(string privatePem,string keyId){key=ECDsa.Create();key.ImportFromPem(privatePem);kid=keyId; if(string.IsNullOrWhiteSpace(kid)||kid.Contains('.'))throw new ArgumentException("Invalid kid");}
 static string Encode(byte[] b)=>Convert.ToBase64String(b).TrimEnd('=').Replace('+','-').Replace('/','_');
 static byte[] Decode(string s)=>Convert.FromBase64String(s.Replace('-','+').Replace('_','/').PadRight((s.Length+3)/4*4,'='));
 static string Hash(byte[] nonce)=>Convert.ToHexString(SHA256.HashData(nonce));
 public (string Payload,string NonceHash) Sign(Guid challenge,DateTime expires){var nonce=RandomNumberGenerator.GetBytes(32);var body=$"hp1.{kid}.{challenge:N}.{new DateTimeOffset(DateTime.SpecifyKind(expires,DateTimeKind.Utc)).ToUnixTimeSeconds()}.{Encode(nonce)}";byte[] signature;lock(gate)signature=key.SignData(Encoding.UTF8.GetBytes(body),HashAlgorithmName.SHA256);return (body+"."+Encode(signature),Hash(nonce));}
 public (Guid Challenge,string NonceHash,DateTime Expires) Validate(string payload,DateTime now){try{if(payload.Length>2048)throw new System.FormatException();var parts=payload.Split('.');if(parts.Length!=6||parts[0]!="hp1"||parts[1]!=kid)throw new System.FormatException();var body=string.Join('.',parts.Take(5));bool valid;lock(gate)valid=key.VerifyData(Encoding.UTF8.GetBytes(body),Decode(parts[5]),HashAlgorithmName.SHA256);if(!valid)throw new System.FormatException();var id=Guid.ParseExact(parts[2],"N");var expires=DateTimeOffset.FromUnixTimeSeconds(long.Parse(parts[3],CultureInfo.InvariantCulture)).UtcDateTime;var nonce=Decode(parts[4]);if(nonce.Length!=32||expires<=now)throw new System.FormatException();return(id,Hash(nonce),expires);}catch(Exception e)when(e is System.FormatException or ArgumentException or CryptographicException or OverflowException){throw new RuleViolation("INVALID_QR");}}
 public string RenderQr(string payload){using var data=QRCodeGenerator.GenerateQrCode(payload,QRCodeGenerator.ECCLevel.Q);using var code=new SvgQRCode(data);return code.GetGraphic(5);}
 public string RenderBarcode(string payload){var writer=new BarcodeWriterSvg{Format=BarcodeFormat.PDF_417,Options=new EncodingOptions{Width=600,Height=220,Margin=10}};return writer.Write(payload).Content;}
 public void Dispose()=>key.Dispose();
}

