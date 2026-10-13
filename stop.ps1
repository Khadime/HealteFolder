#requires -Version 7.0
[CmdletBinding()]
param([switch]$Infrastructure)

$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot
$processFile = Join-Path $projectRoot 'work/processes.json'

if (Test-Path -LiteralPath $processFile) {
    $tracked = Get-Content -LiteralPath $processFile -Raw | ConvertFrom-Json
    foreach ($entry in $tracked.PSObject.Properties) {
        $processId = [int]$entry.Value
        $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
        if ($null -eq $process) { continue }

        $commandLine = (Get-CimInstance Win32_Process -Filter "ProcessId=$processId" -ErrorAction SilentlyContinue).CommandLine
        if ($process.ProcessName -ne 'dotnet' -or $commandLine -notmatch 'HealthPlatform\.(Api|Blazor|Workers)') {
            Write-Warning "PID $processId ignore : il ne correspond plus a un processus HealthPlatform suivi."
            continue
        }

        Stop-Process -Id $processId -Force
        Write-Host "Processus $($entry.Name) arrete (PID $processId)."
    }
    Remove-Item -LiteralPath $processFile -Force
}
else {
    Write-Host 'Aucun processus HealthPlatform suivi dans work/processes.json.'
}

if ($Infrastructure) {
    Set-Location -LiteralPath $projectRoot
    docker compose --env-file .env down
    if ($LASTEXITCODE -ne 0) { throw "docker compose down a echoue ($LASTEXITCODE)." }
}
