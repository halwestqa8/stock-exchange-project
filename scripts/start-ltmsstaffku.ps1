$ErrorActionPreference = 'Stop'

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    $scriptPath = $MyInvocation.MyCommand.Path
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`""
    exit 0
}

$projectRoot = Split-Path -Parent $PSScriptRoot
$composeFile = Join-Path $projectRoot 'docker-compose.staff.local.yml'
$dockerDesktop = 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
$hostsPath = 'C:\Windows\System32\drivers\etc\hosts'
$hostEntry = '127.0.0.1 ltmsstaffku'

if (-not (Test-Path -LiteralPath $composeFile)) {
    throw "Compose file not found: $composeFile"
}

$hostsContent = Get-Content -LiteralPath $hostsPath -ErrorAction SilentlyContinue
if ($hostsContent -notcontains $hostEntry) {
    Add-Content -LiteralPath $hostsPath -Value "`r`n$hostEntry"
}

try {
    Start-Service com.docker.service -ErrorAction Stop
} catch {
    if (Test-Path -LiteralPath $dockerDesktop) {
        Start-Process -FilePath $dockerDesktop
    } else {
        throw 'Docker Desktop is not installed.'
    }
}

$dockerReady = $false
for ($attempt = 1; $attempt -le 60; $attempt++) {
    try {
        docker info | Out-Null
        $dockerReady = $true
        break
    } catch {
        Start-Sleep -Seconds 2
    }
}

if (-not $dockerReady) {
    throw 'Docker Desktop did not become ready in time.'
}

docker compose -f $composeFile up -d --build

Start-Process 'http://ltmsstaffku'
