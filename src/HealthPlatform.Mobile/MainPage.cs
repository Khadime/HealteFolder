using Microsoft.Maui.Controls.Shapes;
using ZXing.Net.Maui;
using ZXing.Net.Maui.Controls;

namespace HealthPlatform.Mobile;

public sealed class MainPage : ContentPage
{
    readonly DashboardViewModel vm;
    readonly List<Border> surfaces = [];
    readonly List<Label> primaryLabels = [];
    readonly List<Label> secondaryLabels = [];

    public MainPage(DashboardViewModel viewModel)
    {
        vm = viewModel;
        BindingContext = vm;
        Title = "Mon espace santé";
        Shell.SetNavBarIsVisible(this, false);

        var content = new VerticalStackLayout { Padding = new Thickness(20, 18, 20, 110), Spacing = 18 };
        content.Children.Add(BuildHeader());
        content.Children.Add(BuildSecurityBanner());
        content.Children.Add(BuildQuickOverview());
        content.Children.Add(BuildQrCard());
        content.Children.Add(BuildStatus());

        var root = new Grid();
        root.Children.Add(new ScrollView { Content = content });
        var navigation = BuildBottomNavigation();
        root.Children.Add(navigation);
        Grid.SetRow(navigation, 0);
        Content = root;

        ApplyTheme(Application.Current?.RequestedTheme ?? AppTheme.Light);
        if (Application.Current is not null) Application.Current.RequestedThemeChanged += (_, e) => ApplyTheme(e.RequestedTheme);
    }

    View BuildHeader()
    {
        var eyebrow = SecondaryLabel("VOTRE ESPACE SANTÉ", 12, FontAttributes.Bold);
        var title = PrimaryLabel("Bienvenue", 30, FontAttributes.Bold);
        title.SetBinding(Label.TextProperty, nameof(vm.DisplayName));
        var subtitle = SecondaryLabel("Votre dossier et vos accès, en toute confiance.", 14);
        var texts = new VerticalStackLayout { Spacing = 2, Children = { eyebrow, title, subtitle } };
        var shield = new Label { Text = "✚", FontSize = 28, TextColor = Colors.White, HorizontalTextAlignment = TextAlignment.Center, VerticalTextAlignment = TextAlignment.Center };
        var mark = new Border { WidthRequest = 54, HeightRequest = 54, BackgroundColor = MobileTheme.Primary, StrokeThickness = 0, StrokeShape = new RoundRectangle { CornerRadius = 16 }, Content = shield };
        var header = new Grid { ColumnDefinitions = { new ColumnDefinition(GridLength.Star), new ColumnDefinition(GridLength.Auto) } };
        header.Children.Add(texts); header.Children.Add(mark); Grid.SetColumn(mark, 1);
        return header;
    }

    View BuildSecurityBanner()
    {
        var icon = new Label { Text = "●", TextColor = MobileTheme.Health, FontSize = 14, VerticalTextAlignment = TextAlignment.Center };
        var title = PrimaryLabel("Protection active", 14, FontAttributes.Bold);
        var text = SecondaryLabel("Chaque accès à votre dossier nécessite votre accord.", 12);
        var labels = new VerticalStackLayout { Spacing = 1, Children = { title, text } };
        var grid = new Grid { ColumnDefinitions = { new ColumnDefinition(24), new ColumnDefinition(GridLength.Star) } };
        grid.Children.Add(icon); grid.Children.Add(labels); Grid.SetColumn(labels, 1);
        return Card(grid, Color.FromArgb("#E8F7F1"), MobileTheme.Health);
    }

    View BuildQuickOverview()
    {
        var grid = new Grid { ColumnSpacing = 12, ColumnDefinitions = { new ColumnDefinition(GridLength.Star), new ColumnDefinition(GridLength.Star) } };
        var results = Metric("Résultats", "—", "Aucune donnée", "◫");
        var appointments = Metric("Rendez-vous", "—", "Aucun prévu", "□");
        grid.Children.Add(results); grid.Children.Add(appointments); Grid.SetColumn(appointments, 1);
        return grid;
    }

    View Metric(string label, string value, string description, string icon)
    {
        var iconLabel = new Label { Text = icon, TextColor = MobileTheme.Primary, FontSize = 22 };
        var caption = SecondaryLabel(label, 12, FontAttributes.Bold);
        var valueLabel = PrimaryLabel(value, 25, FontAttributes.Bold);
        var detail = SecondaryLabel(description, 11);
        return Card(new VerticalStackLayout { Spacing = 5, Children = { iconLabel, caption, valueLabel, detail } });
    }

    View BuildQrCard()
    {
        var title = PrimaryLabel("Partager mon profil", 19, FontAttributes.Bold);
        var subtitle = SecondaryLabel("QR signé · usage unique · 5 minutes", 12);
        var badge = new Border
        {
            Padding = new Thickness(9, 5), BackgroundColor = Color.FromArgb("#E4F7EF"), StrokeThickness = 0,
            StrokeShape = new RoundRectangle { CornerRadius = 99 },
            Content = new Label { Text = "Accès sous votre contrôle", TextColor = MobileTheme.Health, FontSize = 11, FontAttributes = FontAttributes.Bold }
        };
        var heading = new Grid { ColumnDefinitions = { new ColumnDefinition(GridLength.Star), new ColumnDefinition(GridLength.Auto) } };
        heading.Children.Add(new VerticalStackLayout { Spacing = 2, Children = { title, subtitle } }); heading.Children.Add(badge); Grid.SetColumn(badge, 1);

        var barcode = new BarcodeGeneratorView { Format = BarcodeFormat.QrCode, HeightRequest = 230, WidthRequest = 230, HorizontalOptions = LayoutOptions.Center, Margin = new Thickness(0, 10) };
        barcode.SetBinding(BarcodeGeneratorView.ValueProperty, nameof(vm.QrPayload));
        var generate = PrimaryButton("Créer ou régénérer mon QR", "▦");
        generate.SetBinding(Button.CommandProperty, nameof(vm.GenerateQrCommand));
        var scan = new Button { Text = "Scanner un QR professionnel", HeightRequest = 50, CornerRadius = 12, BackgroundColor = Colors.Transparent, BorderColor = MobileTheme.Primary, BorderWidth = 1, TextColor = MobileTheme.Primary, FontAttributes = FontAttributes.Bold };
        scan.Clicked += ScanClicked;
        return Card(new VerticalStackLayout { Spacing = 12, Children = { heading, barcode, generate, scan } });
    }

    View BuildStatus()
    {
        var status = SecondaryLabel("", 13);
        status.SetBinding(Label.TextProperty, nameof(vm.Status));
        SemanticProperties.SetDescription(status, "État de la connexion et des opérations");
        var login = PrimaryButton("Connexion sécurisée", "⌁");
        login.SetBinding(Button.CommandProperty, nameof(vm.LoginCommand));
        return new VerticalStackLayout { Spacing = 10, Children = { login, status } };
    }

    View BuildBottomNavigation()
    {
        var grid = new Grid
        {
            Padding = new Thickness(12, 8, 12, 16), ColumnSpacing = 4,
            VerticalOptions = LayoutOptions.End, BackgroundColor = MobileTheme.LightSurface,
            ColumnDefinitions = { new ColumnDefinition(GridLength.Star), new ColumnDefinition(GridLength.Star), new ColumnDefinition(GridLength.Star), new ColumnDefinition(GridLength.Star) }
        };
        var items = new[] { ("⌂", "Accueil"), ("▤", "Dossier"), ("▦", "Mon QR"), ("●", "Alertes") };
        for (var i = 0; i < items.Length; i++)
        {
            var item = new VerticalStackLayout { Spacing = 1, HorizontalOptions = LayoutOptions.Center, Children = { new Label { Text = items[i].Item1, FontSize = 20, TextColor = i == 0 ? MobileTheme.Primary : MobileTheme.LightMuted, HorizontalTextAlignment = TextAlignment.Center }, new Label { Text = items[i].Item2, FontSize = 10, TextColor = i == 0 ? MobileTheme.Primary : MobileTheme.LightMuted, HorizontalTextAlignment = TextAlignment.Center } } };
            grid.Children.Add(item); Grid.SetColumn(item, i);
        }
        return grid;
    }

    async void ScanClicked(object? sender, EventArgs e)
    {
        if (await Permissions.RequestAsync<Permissions.Camera>() != PermissionStatus.Granted) { vm.Status = "La caméra est requise pour scanner un QR."; return; }
        var camera = new CameraBarcodeReaderView { Options = new BarcodeReaderOptions { Formats = BarcodeFormats.TwoDimensional, AutoRotate = true } };
        var close = new Button { Text = "Fermer", BackgroundColor = Colors.Black.WithAlpha(.65f), TextColor = Colors.White, CornerRadius = 10, Margin = 16, HorizontalOptions = LayoutOptions.End, VerticalOptions = LayoutOptions.Start };
        var overlay = new Label { Text = "Placez le QR du patient dans le cadre", TextColor = Colors.White, FontSize = 17, FontAttributes = FontAttributes.Bold, Margin = new Thickness(20, 70, 20, 0), HorizontalTextAlignment = TextAlignment.Center, VerticalOptions = LayoutOptions.Start };
        var layout = new Grid(); layout.Children.Add(camera); layout.Children.Add(overlay); layout.Children.Add(close);
        var scanner = new ContentPage { Title = "Scanner", BackgroundColor = Colors.Black, Content = layout };
        close.Clicked += async (_, _) => await Navigation.PopModalAsync();
        var handled = false;
        camera.BarcodesDetected += (_, args) => { if (handled || args.Results.Length == 0) return; handled = true; camera.IsDetecting = false; MainThread.BeginInvokeOnMainThread(async () => { await Navigation.PopModalAsync(); await vm.Scan(args.Results[0].Value); }); };
        await Navigation.PushModalAsync(scanner);
    }

    Border Card(View content, Color? background = null, Color? stroke = null)
    {
        var border = new Border { Padding = 17, BackgroundColor = background ?? MobileTheme.LightSurface, Stroke = stroke ?? MobileTheme.LightBorder, StrokeThickness = 1, StrokeShape = new RoundRectangle { CornerRadius = 16 }, Content = content };
        surfaces.Add(border); return border;
    }
    Label PrimaryLabel(string text, double size, FontAttributes attributes = FontAttributes.None) { var label = new Label { Text = text, FontSize = size, FontAttributes = attributes, TextColor = MobileTheme.LightText }; primaryLabels.Add(label); return label; }
    Label SecondaryLabel(string text, double size, FontAttributes attributes = FontAttributes.None) { var label = new Label { Text = text, FontSize = size, FontAttributes = attributes, TextColor = MobileTheme.LightMuted }; secondaryLabels.Add(label); return label; }
    static Button PrimaryButton(string text, string icon) => new() { Text = $"{icon}  {text}", HeightRequest = 52, CornerRadius = 12, BackgroundColor = MobileTheme.Primary, TextColor = Colors.White, FontAttributes = FontAttributes.Bold };
    void ApplyTheme(AppTheme theme)
    {
        var dark = theme == AppTheme.Dark; BackgroundColor = dark ? MobileTheme.DarkBackground : MobileTheme.LightBackground;
        foreach (var surface in surfaces) if (surface.BackgroundColor == MobileTheme.LightSurface || surface.BackgroundColor == MobileTheme.DarkSurface) { surface.BackgroundColor = dark ? MobileTheme.DarkSurface : MobileTheme.LightSurface; surface.Stroke = dark ? MobileTheme.DarkBorder : MobileTheme.LightBorder; }
        foreach (var label in primaryLabels) label.TextColor = dark ? MobileTheme.DarkText : MobileTheme.LightText;
        foreach (var label in secondaryLabels) label.TextColor = dark ? MobileTheme.DarkMuted : MobileTheme.LightMuted;
    }
}
