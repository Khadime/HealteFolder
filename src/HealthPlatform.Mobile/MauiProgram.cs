using CommunityToolkit.Maui;using ZXing.Net.Maui.Controls;
namespace HealthPlatform.Mobile;
public static class MauiProgram { public static MauiApp CreateMauiApp()=>MauiApp.CreateBuilder().UseMauiApp<App>().UseMauiCommunityToolkit().UseBarcodeReader().ConfigureServices().Build();
 static MauiAppBuilder ConfigureServices(this MauiAppBuilder b){b.Services.AddSingleton<MobileSession>();b.Services.AddSingleton<DashboardViewModel>();b.Services.AddSingleton<MainPage>();return b;}}
public sealed class App(MainPage page):Application {protected override Window CreateWindow(IActivationState? activationState)=>new(page);}
