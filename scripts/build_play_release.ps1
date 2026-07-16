# Genera el AAB listo para Google Play Console.
# Requisitos: android/key.properties + upload-keystore.jks + config/env.prod.json

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

if (-not (Test-Path "config/env.prod.json")) {
    Write-Error "Crea config/env.prod.json desde config/env.prod.json.example"
}

if (-not (Test-Path "android/key.properties")) {
    Write-Error "Crea android/key.properties desde android/key.properties.example y genera upload-keystore.jks"
}

flutter clean
flutter pub get
flutter build appbundle --release `
    --dart-define-from-file=config/env.prod.json `
    --obfuscate `
    --split-debug-info=build/app/outputs/symbols

Write-Host ""
Write-Host "AAB generado:" -ForegroundColor Green
Write-Host "build/app/outputs/bundle/release/app-release.aab"
