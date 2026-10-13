#requires -Version 7.0
[CmdletBinding()]
param([string]$BaseUrl = 'http://localhost:8080')

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$settings = Get-Content -LiteralPath (Join-Path $root '.env') | ConvertFrom-StringData

foreach ($attempt in 1..60) {
    try {
        Invoke-RestMethod -Uri "$BaseUrl/realms/health/.well-known/openid-configuration" -TimeoutSec 3 | Out-Null
        break
    }
    catch {
        if ($attempt -eq 60) { throw 'Keycloak ne repond pas sur localhost:8080 apres 120 secondes.' }
        if ($attempt % 5 -eq 0) { Write-Host "Attente de Keycloak... $($attempt * 2) s" }
        Start-Sleep -Seconds 2
    }
}

$token = Invoke-RestMethod -Method Post -Uri "$BaseUrl/realms/master/protocol/openid-connect/token" -ContentType 'application/x-www-form-urlencoded' -Body @{
    grant_type = 'password'
    client_id = 'admin-cli'
    username = 'admin'
    password = $settings.KEYCLOAK_ADMIN_PASSWORD
}
$headers = @{ Authorization = "Bearer $($token.access_token)" }
$admin = "$BaseUrl/admin/realms/health"

$realm = Invoke-RestMethod -Uri $admin -Headers $headers
$realm.registrationAllowed = $false
$realm.resetPasswordAllowed = $true
$realm.verifyEmail = $false
$realm.loginWithEmailAllowed = $true
$realm.passwordPolicy = 'length(12) and upperCase(1) and lowerCase(1) and digits(1) and notUsername(undefined)'
Invoke-RestMethod -Method Put -Uri $admin -Headers $headers -ContentType 'application/json' -Body ($realm | ConvertTo-Json -Depth 100) | Out-Null

$verifyAction = Invoke-RestMethod -Uri "$admin/authentication/required-actions/VERIFY_EMAIL" -Headers $headers
$verifyAction.enabled = $false
$verifyAction.defaultAction = $false
Invoke-RestMethod -Method Put -Uri "$admin/authentication/required-actions/VERIFY_EMAIL" -Headers $headers -ContentType 'application/json' -Body ($verifyAction | ConvertTo-Json -Depth 20) | Out-Null

function Get-Client([string]$clientId) {
    $items = @(Invoke-RestMethod -Uri "$admin/clients?clientId=$([Uri]::EscapeDataString($clientId))" -Headers $headers)
    return $items | Where-Object clientId -eq $clientId | Select-Object -First 1
}

$web = Get-Client 'health-web'
if ($null -ne $web) {
    $web.secret = $settings.HEALTH_WEB_SECRET
    Invoke-RestMethod -Method Put -Uri "$admin/clients/$($web.id)" -Headers $headers -ContentType 'application/json' -Body ($web | ConvertTo-Json -Depth 30) | Out-Null
}

$registration = Get-Client 'health-registration'
if ($null -eq $registration) {
    $registrationBody = @{
        clientId = 'health-registration'; name = 'HealthPlatform Registration Service'; enabled = $true
        publicClient = $false; secret = $settings.HEALTH_REGISTRATION_SECRET; serviceAccountsEnabled = $true
        standardFlowEnabled = $false; directAccessGrantsEnabled = $false
    }
    Invoke-RestMethod -Method Post -Uri "$admin/clients" -Headers $headers -ContentType 'application/json' -Body ($registrationBody | ConvertTo-Json) | Out-Null
    $registration = Get-Client 'health-registration'
}
else {
    $registration.secret = $settings.HEALTH_REGISTRATION_SECRET
    $registration.enabled = $true
    $registration.serviceAccountsEnabled = $true
    $registration.standardFlowEnabled = $false
    $registration.directAccessGrantsEnabled = $false
    Invoke-RestMethod -Method Put -Uri "$admin/clients/$($registration.id)" -Headers $headers -ContentType 'application/json' -Body ($registration | ConvertTo-Json -Depth 30) | Out-Null
}

$serviceUser = Invoke-RestMethod -Uri "$admin/clients/$($registration.id)/service-account-user" -Headers $headers
$realmManagement = Get-Client 'realm-management'
$managementRoles = foreach ($roleName in 'manage-users','query-users','view-users') {
    Invoke-RestMethod -Uri "$admin/clients/$($realmManagement.id)/roles/$roleName" -Headers $headers
}
Invoke-RestMethod -Method Post -Uri "$admin/users/$($serviceUser.id)/role-mappings/clients/$($realmManagement.id)" -Headers $headers -ContentType 'application/json' -Body ($managementRoles | ConvertTo-Json -Depth 20 -AsArray) | Out-Null

try {
    $defaultRole = Invoke-RestMethod -Uri "$admin/roles/default-roles-health" -Headers $headers
    $patientRole = Invoke-RestMethod -Uri "$admin/roles/patient" -Headers $headers
    Invoke-RestMethod -Method Delete -Uri "$admin/roles-by-id/$($defaultRole.id)/composites" -Headers $headers -ContentType 'application/json' -Body (@($patientRole) | ConvertTo-Json -Depth 20 -AsArray) | Out-Null
}
catch { Write-Warning 'Le role patient ne figurait pas dans les roles par defaut, ou il etait deja retire.' }

$profile = Get-Content -LiteralPath (Join-Path $root 'deployment/docker/user-profile.json') -Raw
Invoke-RestMethod -Method Put -Uri "$admin/users/profile" -Headers $headers -ContentType 'application/json' -Body $profile | Out-Null

Write-Host 'Keycloak configure : inscription controlee, roles explicites, verification courriel desactivee.'
