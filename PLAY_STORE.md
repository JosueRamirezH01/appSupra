# Publicar en Google Play — Supra (`com.cimak.supra`)

## 1. Una sola vez: keystore de release

```powershell
cd android
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
copy key.properties.example key.properties
# Edita key.properties con tus contraseñas
```

Guarda `upload-keystore.jks` y las contraseñas en un lugar seguro.

Obtén el SHA-1 para Google Cloud (Maps + Sign-In):

```powershell
keytool -list -v -keystore upload-keystore.jks -alias upload
```

## 2. Configurar entornos

```powershell
copy config\env.dev.json.example config\env.dev.json
copy config\env.prod.json.example config\env.prod.json
```

Edita `config/env.prod.json` con tu API HTTPS real y el `GOOGLE_SERVER_CLIENT_ID` de producción.

`android/local.properties` debe incluir `GOOGLE_MAPS_API_KEY` restringida a `com.cimak.supra` + SHA-1 release.

## 3. Desarrollo (como ahora)

```powershell
flutter run --dart-define-from-file=config/env.dev.json
```

## 4. Generar AAB para Play Store

```powershell
.\scripts\build_play_release.ps1
```

Salida: `build/app/outputs/bundle/release/app-release.aab`

## 5. Cambios ya hechos en el proyecto

| Archivo | Cambio |
|---------|--------|
| `android/app/build.gradle` | Firma release con `key.properties` (obligatorio) |
| `android/app/src/main/res/values/strings.xml` | Nombre **Supra** |
| `AndroidManifest.xml` | Sin HTTP en release; sin ubicación en segundo plano |
| `debug/.../network_security_config.xml` | HTTP solo en debug |
| `lib/core/config/app_config.dart` | Sin ngrok por defecto; flags de prod |
| `config/env.*.json.example` | Variables por entorno |
| `scripts/build_play_release.ps1` | Build AAB ofuscado |

## 6. Play Console (manual)

- [ ] Cuenta desarrollador (~USD 25)
- [ ] Ficha: título, descripción, screenshots, ícono 512×512
- [ ] URL de política de privacidad
- [ ] Data safety (email, teléfono, ubicación, fotos, documentos)
- [ ] Declaración de permisos (cámara, ubicación)
- [ ] Internal testing → producción

## 7. Backend en producción

- API en `https://api.tudominio.com` (misma URL que `env.prod.json`)
- `API_PUBLIC_URL` en el backend para URLs de imágenes
- JWT y secrets de producción (sin `changeme`)
