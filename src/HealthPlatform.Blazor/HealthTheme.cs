using MudBlazor;

namespace HealthPlatform.Blazor;

public static class HealthTheme
{
    public static readonly MudTheme Theme = new()
    {
        PaletteLight = new PaletteLight
        {
            Primary = "#0066CC",
            Secondary = "#008A58",
            Success = "#008A58",
            Warning = "#A15C00",
            Error = "#B42318",
            Info = "#0066CC",
            Background = "#F7F9FC",
            Surface = "#FFFFFF",
            AppbarBackground = "#FFFFFF",
            AppbarText = "#172033",
            DrawerBackground = "#FFFFFF",
            DrawerText = "#334155",
            TextPrimary = "#172033",
            TextSecondary = "#596579",
            Divider = "#DDE5EF"
        },
        PaletteDark = new PaletteDark
        {
            Primary = "#66B2FF",
            Secondary = "#4ADEA3",
            Success = "#4ADEA3",
            Warning = "#FBBF24",
            Error = "#FF8A80",
            Info = "#66B2FF",
            Background = "#0B1220",
            Surface = "#142033",
            AppbarBackground = "#101A2B",
            AppbarText = "#F1F5F9",
            DrawerBackground = "#101A2B",
            DrawerText = "#D8E2EF",
            TextPrimary = "#F1F5F9",
            TextSecondary = "#AAB7C8",
            Divider = "#2B3A50"
        },
        LayoutProperties = new LayoutProperties { DefaultBorderRadius = "12px" }
    };
}
