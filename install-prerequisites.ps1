#requires -Version 5.1
#requires -RunAsAdministrator
<#
Installs the global Windows development toolchain. Run from an elevated terminal.
Does not remove existing Visual Studio or MySQL installations and never reboots automatically.
#>
[CmdletBinding()]
param([switch]$SkipVisualStudio, [switch]$DevOpsTools, [switch]$SkipDockerStart)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$projectRoot = $PSScriptRoot
$logDirectory = Join-Path $projectRoot 'work\installation'
New-Item -ItemType Directory -Force -Path $logDirectory | Out-Null
Start-Transcript -Path (Join-Path $logDirectory ('prerequisites-' + (Get-Date -Format yyyyMMdd-HHmmss) + '.log')) | Out-Null
try {
    $winget = (Get-Command winget.exe -ErrorAction Stop).Source
    function Ensure-PowerShell7 {
        $installDirectory = Join-Path $env:ProgramFiles 'PowerShell\7'
        $executable = Join-Path $installDirectory 'pwsh.exe'
        if (Test-Path -LiteralPath $executable) {
            $installedVersion = & $executable -NoProfile -Command '$PSVersionTable.PSVersion.ToString()'
            if ($LASTEXITCODE -eq 0 -and [version]$installedVersion -ge [version]'7.0') {
                Write-Host "PowerShell $installedVersion est déjà installé globalement."
                return
            }
        }

        # The winget MSI can fail with 0x80070005 when launched from Windows PowerShell.
        # Microsoft's documented ZIP distribution avoids that self-install/update lock.
        $version = '7.6.6'
        $expectedSha256 = '02FE458BE20493FBDF43F61EA20610B811EE6C738AB1676C61B9CFCD1A33C860'
        $archive = Join-Path $env:TEMP "PowerShell-$version-win-x64.zip"
        $uri = "https://github.com/PowerShell/PowerShell/releases/download/v$version/PowerShell-$version-win-x64.zip"
        Write-Host "Installation globale de PowerShell $version depuis l'archive Microsoft officielle."
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -UseBasicParsing -Uri $uri -OutFile $archive
        $actualSha256 = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash
        if ($actualSha256 -ne $expectedSha256) { throw 'Le contrôle SHA-256 de PowerShell a échoué.' }
        New-Item -ItemType Directory -Force -Path $installDirectory | Out-Null
        Expand-Archive -LiteralPath $archive -DestinationPath $installDirectory -Force
        if (-not (Test-Path -LiteralPath $executable)) { throw 'pwsh.exe absent après extraction.' }
        $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
        if (($machinePath -split ';') -notcontains $installDirectory) {
            [Environment]::SetEnvironmentVariable('Path', ($machinePath.TrimEnd(';') + ';' + $installDirectory), 'Machine')
        }
        $env:PATH = $installDirectory + ';' + $env:PATH
        Write-Host "PowerShell installé : $(& $executable -NoProfile -Command '$PSVersionTable.PSVersion.ToString()')"
    }

    function Install-Package([string]$Id, [string[]]$Extra = @()) {
        Write-Host "Installation / vérification : $Id"
        & $winget install --id $Id --exact --source winget --scope machine --silent --accept-source-agreements --accept-package-agreements --disable-interactivity @Extra
        $code = $LASTEXITCODE
        # APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE: installed and no update available.
        if ($code -notin @(0, 3010, -1978335189)) {
            throw "Installation de $Id échouée (code $code). Voir le journal winget."
        }
        if ($code -eq 3010) { Write-Warning 'Un redémarrage Windows est nécessaire. Aucun redémarrage automatique.' }
    }

    Ensure-PowerShell7
    Install-Package 'Microsoft.DotNet.SDK.10'
    Install-Package 'Microsoft.OpenJDK.21'
    if (-not $SkipVisualStudio) {
        Install-Package 'Microsoft.VisualStudio.Community' @('--override', '--passive --wait --norestart --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.NetCrossPlat --includeRecommended')
    }
    Install-Package 'Docker.DockerDesktop'

    # Refresh the process PATH after machine-wide installation.
    $env:PATH = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
    $globalDotnet = Join-Path $env:ProgramFiles 'dotnet\dotnet.exe'
    Push-Location -LiteralPath $projectRoot
    try {
        $sdk = & $globalDotnet --version
        if ($LASTEXITCODE -ne 0 -or $sdk -notmatch '^10\.') { throw 'Le SDK global .NET 10 ne peut pas être sélectionné.' }
        & $globalDotnet workload install maui-android maui-windows --source https://api.nuget.org/v3/index.json
        if ($LASTEXITCODE -ne 0) { throw 'Installation des workloads MAUI échouée.' }
        $androidSdk = Join-Path ${env:ProgramFiles(x86)} 'Android\android-sdk'
        $javaSdk = Get-ChildItem -LiteralPath (Join-Path $env:ProgramFiles 'Microsoft') -Directory -Filter 'jdk-21*' -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
        if (-not $javaSdk) { throw 'OpenJDK 21 global introuvable après installation.' }
        & $globalDotnet build 'src/HealthPlatform.Mobile/HealthPlatform.Mobile.csproj' -t:InstallAndroidDependencies -f net10.0-android "-p:AndroidSdkDirectory=$androidSdk" "-p:JavaSdkDirectory=$javaSdk" -p:AcceptAndroidSdkLicenses=True
        if ($LASTEXITCODE -ne 0) { throw 'Installation du SDK Android / JDK échouée.' }
        [Environment]::SetEnvironmentVariable('ANDROID_HOME', $androidSdk, 'Machine')
        [Environment]::SetEnvironmentVariable('JAVA_HOME', $javaSdk, 'Machine')
        $installedTools = & $globalDotnet tool list --global
        if ($installedTools -match '^dotnet-ef\s') {
            & $globalDotnet tool update --global dotnet-ef --version 9.0.20 --allow-roll-forward
        } else {
            & $globalDotnet tool install --global dotnet-ef --version 9.0.20 --allow-roll-forward
        }
        if ($LASTEXITCODE -ne 0) { throw 'Installation de dotnet-ef échouée.' }
        & $globalDotnet --list-sdks
        & $globalDotnet workload list
    } finally { Pop-Location }

    if ($DevOpsTools) {
        Install-Package 'Microsoft.AzureCLI'
        Install-Package 'Hashicorp.Terraform'
        Install-Package 'Kubernetes.kubectl'
        Install-Package 'Helm.Helm'
    }
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (-not $SkipVisualStudio) {
        $instance = & $vswhere -version '[18.0,19.0)' -products '*' -requires Microsoft.VisualStudio.Workload.NetWeb Microsoft.VisualStudio.Workload.NetCrossPlat -property installationPath
        if (-not $instance) { throw 'Visual Studio 2026 avec ASP.NET et MAUI non détecté. Vérifier Visual Studio Installer.' }
        Write-Host "IDE compatible : $instance"
    }
    if (-not $SkipDockerStart) {
        $desktop = Join-Path $env:ProgramFiles 'Docker\Docker\Docker Desktop.exe'
        if (-not (Get-Process -Name 'Docker Desktop' -ErrorAction SilentlyContinue)) {
            Start-Process -FilePath $desktop -WindowStyle Hidden | Out-Null
        }
        Write-Host 'Docker Desktop peut nécessiter sa configuration initiale ou un redémarrage Windows/WSL.'
    }
    Write-Host 'Pré-requis installés. Vous pouvez rester dans ce terminal ou ouvrir PowerShell 7.'
    Write-Host ('Commande universelle : Set-Location "' + $projectRoot + '"; .\setup.cmd -Test')
    Write-Host 'MySQL existant conservé. Keycloak, Redis et RabbitMQ sont lancés par Docker Compose dans setup.ps1.'
} finally {
    Stop-Transcript | Out-Null
}
