#requires -Version 7.0
[CmdletBinding()]
param([switch]$SkipDocker,[switch]$SkipDatabase,[switch]$NoLaunch,[switch]$Test,[switch]$Mobile,[switch]$LocalMySqlWithoutTls,[string]$NuGetConfig,[string]$ConnectionString='server=localhost;port=3306;database=HealthPlatform;user=root;password=')
$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest
$projectRoot=$PSScriptRoot
Set-Location -LiteralPath $projectRoot
$globalDotnet=Join-Path $env:ProgramFiles 'dotnet/dotnet.exe'
$hasGlobalSdk=(Test-Path $globalDotnet) -and ((& $globalDotnet --list-sdks) -match '^10\.')
$dotnet=if($hasGlobalSdk){$globalDotnet}elseif(Test-Path '.dotnet/dotnet.exe'){Join-Path $projectRoot '.dotnet/dotnet.exe'}else{throw 'SDK .NET 10 absent. Exécuter install-prerequisites.ps1 dans un terminal administrateur.'}
$env:DOTNET_ROOT=Split-Path $dotnet -Parent
$env:DOTNET_CLI_HOME=Join-Path $projectRoot 'work/cli'
$env:NUGET_PACKAGES=Join-Path $projectRoot 'work/packages'
$env:NUGET_HTTP_CACHE_PATH=Join-Path $projectRoot 'work/http-cache'
$env:DOTNET_CLI_TELEMETRY_OPTOUT='1'
$env:HEALTH_CLI_BUILD='true'
$env:PATH=(Split-Path $dotnet -Parent)+[IO.Path]::PathSeparator+$env:PATH
function Run([string]$Command,[string[]]$Arguments){& $Command @Arguments;if($LASTEXITCODE-ne 0){throw "$Command failed ($LASTEXITCODE)"}}
function Wait-DockerEngine {
 $dockerDesktop=Join-Path $env:ProgramFiles 'Docker\Docker\Docker Desktop.exe'
 if(!(Get-Command docker -ErrorAction SilentlyContinue)){throw 'Docker CLI absent. Exécuter install-prerequisites.ps1 en administrateur.'}
 foreach($context in @('desktop-linux','default')){& docker --context $context info *> $null;if($LASTEXITCODE-eq 0){return $context}}
 if(!(Test-Path -LiteralPath $dockerDesktop)){throw "Docker Desktop absent : $dockerDesktop"}
 Write-Host 'Démarrage de Docker Desktop...'
 if(!(Get-Process -Name 'Docker Desktop' -ErrorAction SilentlyContinue)){Start-Process -FilePath $dockerDesktop | Out-Null}
 for($attempt=1;$attempt-le 60;$attempt++){
  Start-Sleep -Seconds 2
  foreach($context in @('desktop-linux','default')){& docker --context $context info *> $null;if($LASTEXITCODE-eq 0){Write-Host "Moteur Docker prêt (contexte $context).";return $context}}
  if($attempt%5-eq 0){Write-Host "Attente du moteur Docker... $($attempt*2) s"}
 }
 throw "Docker Desktop n'est pas devenu disponible. Ouvrir Docker Desktop, terminer sa configuration WSL/CGU, puis relancer setup.cmd. Pour un démarrage serveur limité : setup.cmd -SkipDocker -LocalMySqlWithoutTls."
}
$sdk=& $dotnet --version
if($LASTEXITCODE-ne 0-or [version]$sdk-lt[version]'10.0.100'){throw 'Install .NET 10 SDK; Visual Studio 2026 is required for IDE builds.'}
$names='Api','Application','Domain','Infrastructure','Persistence','Contracts','SharedKernel','Blazor','Mobile','Gateway','Workers'
$tests='UnitTests','IntegrationTests','ArchitectureTests'
foreach($folder in @('database/migrations','database/scripts','database/seed','deployment/docker','deployment/kubernetes','deployment/terraform','deployment/github-actions','docs','work','.secrets')){New-Item -ItemType Directory -Force -Path $folder|Out-Null}
# Source is versioned; refuse to replace a missing application with an empty template.
foreach($name in $names){if(!(Test-Path "src/HealthPlatform.$name/HealthPlatform.$name.csproj")){throw "Incomplete checkout: missing HealthPlatform.$name. Restore the source distribution."}}
if(!(Test-Path HealthPlatform.sln)){Run $dotnet @('new','sln','--format','sln','-n','HealthPlatform')}
foreach($name in $names){Run $dotnet @('sln','HealthPlatform.sln','add',"src/HealthPlatform.$name/HealthPlatform.$name.csproj")}
foreach($name in $tests){Run $dotnet @('sln','HealthPlatform.sln','add',"tests/HealthPlatform.$name/HealthPlatform.$name.csproj")}
$serverProjects=@($names|Where-Object {$_-ne'Mobile'}|ForEach-Object {"src/HealthPlatform.$_/HealthPlatform.$_.csproj"})+@($tests|ForEach-Object {"tests/HealthPlatform.$_/HealthPlatform.$_.csproj"})
@{solution=@{path='HealthPlatform.sln';projects=$serverProjects}}|ConvertTo-Json -Depth 5|Set-Content HealthPlatform.Server.slnf -Encoding utf8
if(!(Test-Path '.secrets/qr-private.pem')){$key=[Security.Cryptography.ECDsa]::Create([Security.Cryptography.ECCurve+NamedCurves]::nistP256);try{$key.ExportPkcs8PrivateKeyPem()|Set-Content '.secrets/qr-private.pem' -NoNewline}finally{$key.Dispose()}}
function Secret{[Convert]::ToHexString([Security.Cryptography.RandomNumberGenerator]::GetBytes(32))}
if(!(Test-Path '.env')){@("MYSQL_ROOT_PASSWORD=$(Secret)","RABBITMQ_PASSWORD=$(Secret)","KEYCLOAK_ADMIN_PASSWORD=$(Secret)","HEALTH_WEB_SECRET=$(Secret)","HEALTH_REGISTRATION_SECRET=$(Secret)")|Set-Content '.env'}
elseif(-not (Select-String -LiteralPath '.env' -Pattern '^HEALTH_REGISTRATION_SECRET=' -Quiet)){Add-Content -LiteralPath '.env' -Value "HEALTH_REGISTRATION_SECRET=$(Secret)"}
if(!$SkipDocker){$dockerContext=Wait-DockerEngine;Run 'docker' @('--context',$dockerContext,'compose','--env-file','.env','up','-d');Run (Join-Path $PSHOME 'pwsh.exe') @('-NoProfile','-File',(Join-Path $projectRoot 'configure-keycloak.ps1'));Write-Host 'Keycloak configure pour les inscriptions Patient et Professionnel.'}
$restore=@('restore','HealthPlatform.Server.slnf');if($NuGetConfig){$restore+=@('--configfile',$NuGetConfig)}else{$restore+=@('--configfile','NuGet.Config')}
Run $dotnet $restore
Run $dotnet @('build','HealthPlatform.Server.slnf','--no-restore','-c','Release','-m:1','-nr:false')
$tools=Join-Path $projectRoot 'work/tools'
$ef=Join-Path $tools 'dotnet-ef.exe'
if(!(Test-Path $ef)){$argsEf=@('tool','install','dotnet-ef','--version','9.0.20','--tool-path',$tools);if($NuGetConfig){$argsEf+=@('--configfile',$NuGetConfig)};Run $dotnet $argsEf}
if($LocalMySqlWithoutTls){if($ConnectionString-notmatch 'server=(localhost|127\.0\.0\.1);'){throw 'Non-TLS override is restricted to loopback development.'};$ConnectionString+=';SslMode=None'}
$env:ConnectionStrings__DefaultConnection=$ConnectionString
if(!$SkipDatabase){Run $ef @('database','update','--project','src/HealthPlatform.Persistence','--configuration','Release','--no-build')}
if($Test){$env:HEALTH_TEST_MYSQL=$ConnectionString;Run $dotnet @('test','HealthPlatform.Server.slnf','--no-build','--no-restore','-c','Release','-m:1','--collect:XPlat Code Coverage','--test-adapter-path',(Join-Path $env:NUGET_PACKAGES 'coverlet.collector/6.0.4/build/netstandard2.0'),'--results-directory','work/TestResults')}
if($Mobile){
 Run $dotnet @('workload','restore','src/HealthPlatform.Mobile/HealthPlatform.Mobile.csproj')
 $androidSdk=Join-Path $projectRoot '.android-sdk';$javaSdk=Join-Path $projectRoot '.jdk/jdk-21.0.12.1+1'
 Run $dotnet @('build','src/HealthPlatform.Mobile/HealthPlatform.Mobile.csproj','-c','Debug','-f','net10.0-android',"-p:AndroidSdkDirectory=$androidSdk","-p:JavaSdkDirectory=$javaSdk",'-p:Aapt2DaemonMaxInstanceCount=1','-m:1','-nr:false')
}
if(!$NoLaunch){
 $env:Qr__PrivateKeyPath=Join-Path $projectRoot '.secrets/qr-private.pem'
 $settings=Get-Content '.env'|ConvertFrom-StringData
 $env:Authentication__ClientSecret=$settings.HEALTH_WEB_SECRET
 $env:Registration__ClientSecret=$settings.HEALTH_REGISTRATION_SECRET
 $env:RabbitMq__Password=$settings.RABBITMQ_PASSWORD
 $env:RabbitMq__Enabled=(!$SkipDocker).ToString()
 # Separate hidden processes; PIDs retained for explicit shutdown.
 $api=Start-Process -FilePath $dotnet -ArgumentList @('run','--no-build','-c','Release','--project','src/HealthPlatform.Api') -WorkingDirectory $projectRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput 'work/api.log' -RedirectStandardError 'work/api.error.log'
 $web=Start-Process -FilePath $dotnet -ArgumentList @('run','--no-build','-c','Release','--project','src/HealthPlatform.Blazor') -WorkingDirectory $projectRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput 'work/web.log' -RedirectStandardError 'work/web.error.log'
 $processIds=@{api=$api.Id;web=$web.Id}
 if(!$SkipDocker){$worker=Start-Process -FilePath $dotnet -ArgumentList @('run','--no-build','-c','Release','--project','src/HealthPlatform.Workers') -WorkingDirectory $projectRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput 'work/worker.log' -RedirectStandardError 'work/worker.error.log';$processIds.worker=$worker.Id}
 $processIds|ConvertTo-Json|Set-Content 'work/processes.json'
 Write-Host 'API http://localhost:5100 ; Web https://localhost:7101. Trust the dev certificate with dotnet dev-certs https --trust if needed.'
}
