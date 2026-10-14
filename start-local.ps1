#requires -Version 7.0
# Local start: MySQL in Docker (container-db profile, port 3307), password read from .env.
[CmdletBinding()]
param([switch]$Test)
$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot
Set-Location -LiteralPath $projectRoot
$dockerBin = Join-Path $env:ProgramFiles 'Docker\Docker\resources\bin'
if ((Test-Path $dockerBin) -and (($env:PATH -split ';') -notcontains $dockerBin)) { $env:PATH = "$dockerBin;$env:PATH" }
if (!(Test-Path '.env')) { throw '.env absent : executer setup.cmd une premiere fois.' }
$settings = Get-Content '.env' -Raw | ConvertFrom-StringData
$env:COMPOSE_PROFILES = 'container-db'
$connection = "server=localhost;port=3307;database=HealthPlatform;user=root;password=$($settings.MYSQL_ROOT_PASSWORD)"
$setupArgs = @{ NuGetConfig = (Join-Path $projectRoot 'NuGet.Config'); ConnectionString = $connection }
if ($Test) { $setupArgs.Test = $true }
& (Join-Path $projectRoot 'setup.ps1') @setupArgs
Write-Host ''
Write-Host 'Portail : https://localhost:7101   API : http://localhost:5100/health/ready'
Write-Host 'Arret : stop.cmd'
