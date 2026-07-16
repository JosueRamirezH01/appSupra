# Desarrollo con ngrok / backend local
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

if (-not (Test-Path "config/env.dev.json")) {
    Copy-Item "config/env.dev.json.example" "config/env.dev.json"
    Write-Host "Creado config/env.dev.json — edítalo si hace falta."
}

flutter run --dart-define-from-file=config/env.dev.json @args
