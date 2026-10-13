using CommunityToolkit.Mvvm.ComponentModel;using CommunityToolkit.Mvvm.Input;using HealthPlatform.Contracts;
namespace HealthPlatform.Mobile;
public partial class DashboardViewModel(MobileSession session):ObservableObject {
 [ObservableProperty]string status="Connectez-vous pour consulter votre dossier.";[ObservableProperty]string qrPayload="";[ObservableProperty]string displayName="Bienvenue";
 Guid? patient;
 [RelayCommand]async Task Login(){try{await session.Login();var me=await session.Get<Me>("me");patient=me?.PatientId;if(patient!=null){var p=await session.Get<PatientDto>($"patients/{patient}");DisplayName=$"{p?.GivenName} {p?.FamilyName}";}Status="Connecté";}catch(Exception){Status="Connexion impossible. Vérifiez le service d'identité et votre réseau.";}}
 [RelayCommand]async Task GenerateQr(){try{if(patient==null){Status="Créez votre profil depuis le portail.";return;}var qr=await session.Post<QrDto>($"patients/{patient}/access-codes",new IssueQrDto());QrPayload=qr!.QrPayload;Status=$"Code valable jusqu'à {qr.ExpiresAt.ToLocalTime():HH:mm:ss}";}catch(Exception){Status="Reconnectez-vous pour créer un code.";}}
 public async Task Scan(string code){try{await session.Post<object>("access-codes/scan",new ScanQrDto(code));Status="Demande envoyée au patient.";}catch(Exception){Status="Code invalide ou accès refusé.";}}
 sealed record Me(Guid? PatientId);
}
