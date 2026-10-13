#requires -Version 7.0
[CmdletBinding()]
param([switch]$BuildOnly)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$dotnet = Join-Path $root '.dotnet\dotnet.exe'
$androidSdk = Join-Path $root '.android-sdk'
$javaSdk = Join-Path $root '.jdk\jdk-21.0.12.1+1'
$adb = Join-Path $androidSdk 'platform-tools\adb.exe'
$project = Join-Path $root 'src\HealthPlatform.Mobile\HealthPlatform.Mobile.csproj'
$env:DOTNET_ROOT = Split-Path $dotnet -Parent
$env:DOTNET_CLI_HOME = Join-Path $root 'work\cli'
$env:NUGET_PACKAGES = Join-Path $root 'work\packages'
$env:NUGET_HTTP_CACHE_PATH = Join-Path $root 'work\http-cache'
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:HEALTH_CLI_BUILD = 'true'
$env:ANDROID_HOME = $androidSdk
$env:JAVA_HOME = $javaSdk

foreach ($required in @($dotnet, $adb, (Join-Path $androidSdk 'platforms\android-36\android.jar'), (Join-Path $javaSdk 'bin\java.exe'))) {
    if (-not (Test-Path -LiteralPath $required)) { throw "Prérequis mobile absent : $required" }
}

$devices = & $adb devices
if (-not $BuildOnly -and -not ($devices -match "(?m)^.+\tdevice$")) {
    throw 'Aucun appareil Android détecté. Démarrez un émulateur dans Android Studio ou activez le débogage USB.'
}

$common = @(
    $project, '-c', 'Debug', '-f', 'net10.0-android',
    "-p:AndroidSdkDirectory=$androidSdk",
    "-p:JavaSdkDirectory=$javaSdk",
    '-p:Aapt2DaemonMaxInstanceCount=1',
    '-m:1', '-nr:false'
)

if ($BuildOnly) {
    & $dotnet build @common
} else {
    & $adb reverse tcp:5100 tcp:5100 | Out-Null
    & $adb reverse tcp:8080 tcp:8080 | Out-Null
    & $dotnet build @common -t:Run
}

if ($LASTEXITCODE -ne 0) { throw "Démarrage mobile échoué ($LASTEXITCODE)." }
