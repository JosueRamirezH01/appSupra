# Servicios Técnicos — App móvil (Flutter)

Cliente móvil para la plataforma de servicios técnicos. Conecta con el backend REST (`/api/v1`), soporta roles **cliente**, **técnico** y **admin**, e incluye autenticación, catálogo, verificación de técnicos, zona de servicio con mapa y panel administrativo básico.

---

## Tabla de contenidos

1. [Requisitos previos](#requisitos-previos)
2. [Stack tecnológico](#stack-tecnológico)
3. [Arquitectura del proyecto](#arquitectura-del-proyecto)
4. [Configuración inicial (onboarding)](#configuración-inicial-onboarding)
5. [Variables y secretos](#variables-y-secretos)
6. [Google Cloud (Maps + Sign-In)](#google-cloud-maps--sign-in)
7. [Ejecutar la app](#ejecutar-la-app)
8. [Generación de código](#generación-de-código)
9. [Módulos funcionales](#módulos-funcionales)
10. [Permisos nativos](#permisos-nativos)
11. [Solución de problemas](#solución-de-problemas)
12. [Comandos útiles](#comandos-útiles)

---

## Requisitos previos

| Herramienta | Versión recomendada | Notas |
|-------------|---------------------|-------|
| **Flutter** | 3.44+ (stable) | Dart **3.12+** incluido |
| **Android Studio** | Última estable | SDK Android 37, emulador o dispositivo físico |
| **JDK** | 17 | Incluido con Android Studio (`jbr`) |
| **Xcode** | 15+ | Solo macOS, para builds iOS |
| **CocoaPods** | Última | Solo iOS: `sudo gem install cocoapods` |
| **Backend** | Node/Express | Debe estar corriendo antes de probar login/API |

Verificar instalación:

```bash
flutter doctor -v
```

Aceptar licencias Android si es necesario:

```bash
flutter doctor --android-licenses
```

> **Windows:** si `flutter pub get` pide *Developer Mode* para symlinks, actívalo en **Configuración → Privacidad y seguridad → Para desarrolladores**.

---

## Stack tecnológico

| Área | Librería |
|------|----------|
| Estado | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) + `riverpod_annotation` |
| Navegación | [go_router](https://pub.dev/packages/go_router) |
| HTTP | [dio](https://pub.dev/packages/dio) |
| Modelos | [freezed](https://pub.dev/packages/freezed) + [json_serializable](https://pub.dev/packages/json_serializable) |
| Auth segura | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) |
| Google Sign-In | [google_sign_in](https://pub.dev/packages/google_sign_in) |
| Mapas | [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) |
| Ubicación | [geolocator](https://pub.dev/packages/geolocator), [geocoding](https://pub.dev/packages/geocoding) |
| UI | Material 3, [google_fonts](https://pub.dev/packages/google_fonts) |
| Imágenes | [image_picker](https://pub.dev/packages/image_picker) |

---

## Arquitectura del proyecto

Clean Architecture simplificada:

```text
lib/
├── core/           # Config, red (Dio), storage, errores, utilidades
├── domain/         # Contratos de repositorios (interfaces)
├── data/           # Datasources, modelos, implementaciones de repos
├── presentation/   # Screens, widgets, providers (Riverpod)
└── routes/         # GoRouter + route_paths
```

**Flujo de datos:** `Screen → Provider/Notifier → Repository → Datasource → API`

**Package name (pub):** `prueba`  
**Application ID (Android):** `com.example.prueba`

---

## Configuración inicial (onboarding)

### 1. Clonar e instalar dependencias

```bash
git clone <URL_DEL_REPO>
cd prueba
flutter pub get
```

### 2. Levantar el backend

El frontend espera la API en `http://<host>:3000/api/v1` por defecto.

Asegúrate de que el backend esté corriendo (ver README del repo backend). Sin backend activo verás errores de red en login y catálogo.

### 3. Android — `local.properties`

El archivo `android/local.properties` **no se versiona** (está en `.gitignore`). Créalo a partir del ejemplo:

```bash
cp android/local.properties.example android/local.properties
```

Edita las rutas según tu máquina:

```properties
sdk.dir=C:\\Users\\TU_USUARIO\\AppData\\Local\\Android\\sdk
flutter.sdk=C:\\src\\flutter
GOOGLE_MAPS_API_KEY=TU_API_KEY_DE_GOOGLE_MAPS
```

> Pide la API key al líder del proyecto o créala en Google Cloud (ver sección [Google Cloud](#google-cloud-maps--sign-in)).

### 4. iOS — API key de Maps

En `ios/Runner/Info.plist`, configura:

```xml
<key>GMSApiKey</key>
<string>TU_API_KEY_DE_GOOGLE_MAPS</string>
```

Luego instala pods:

```bash
cd ios
pod install
cd ..
```

### 5. Generar código (Freezed / Riverpod)

Si clonas el repo y faltan archivos `*.g.dart` o `*.freezed.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Variables y secretos

Configuración central en `lib/core/config/app_config.dart`:

| Variable | Cómo se pasa | Valor por defecto | Uso |
|----------|--------------|-------------------|-----|
| `API_BASE_URL` | `--dart-define` | `http://10.0.2.2:3000/api/v1` | URL base del backend |
| `GOOGLE_SERVER_CLIENT_ID` | `--dart-define` | *(valor del equipo)* | Google Sign-In → backend |
| `GOOGLE_MAPS_API_KEY` | Android: `local.properties` / iOS: `Info.plist` | — | Renderizado de mapas nativos |

### URL del backend según entorno

| Entorno | `API_BASE_URL` |
|---------|----------------|
| Emulador Android | `http://10.0.2.2:3000/api/v1` (default) |
| Simulador iOS | `http://localhost:3000/api/v1` |
| Dispositivo físico | `http://<IP_LAN_DE_TU_PC>:3000/api/v1` |

Ejemplo con dispositivo físico:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.50:3000/api/v1
```

> **Seguridad:** no subas API keys ni tokens a Git. Usa `local.properties`, variables de entorno o un gestor de secretos del equipo.

---

## Google Cloud (Maps + Sign-In)

### Maps SDK

1. [Google Cloud Console](https://console.cloud.google.com/) → **APIs y servicios** → **Biblioteca**
2. Habilitar:
   - **Maps SDK for Android**
   - **Maps SDK for iOS** *(si compilas iOS)*
3. **Credenciales** → crear **API key**
4. Restringir la key:
   - Android: package `com.example.prueba` + huella **SHA-1**
   - iOS: bundle ID del proyecto

### Obtener SHA-1 (Android)

**Opción A — Terminal (desde la carpeta `android`):**

```bash
# Windows (PowerShell), con JDK de Android Studio
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
.\gradlew signingReport
```

**Opción B — keytool (certificado debug):**

```bash
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Copia el valor de la línea `SHA1:`.

### Google Sign-In

1. Mismo proyecto en Google Cloud
2. Credencial OAuth **Web** → ese Client ID va en `GOOGLE_SERVER_CLIENT_ID` (debe coincidir con `GOOGLE_CLIENT_ID` del backend)
3. Credencial OAuth **Android** → package `com.example.prueba` + SHA-1 debug (y release cuando publiquen)

---

## Ejecutar la app

### Emulador Android (desarrollo habitual)

```bash
flutter devices
flutter run
```

### Con URL de backend personalizada

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
```

### Release APK (prueba)

```bash
flutter build apk --release
```

El APK queda en `build/app/outputs/flutter-apk/app-release.apk`.

### iOS (macOS)

```bash
flutter run -d ios
# o
flutter build ios --release
```

---

## Generación de código

Tras modificar modelos `@freezed`, providers `@riverpod` o `@JsonSerializable`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Modo watch durante desarrollo:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Módulos funcionales

| Módulo | Rutas principales | Descripción |
|--------|-------------------|-------------|
| **Auth** | `/preLogin`, `/login`, `/register/*` | Login email/password, Google Sign-In, registro cliente/técnico |
| **Home cliente** | `/` | Catálogo, carrusel, explorar categorías |
| **Home técnico** | `/` (vista técnico) | Panel, stats, banner zona de servicio, acciones rápidas |
| **Técnicos** | `/technicians`, `/technicians/:userId` | Listado cercano (geo), detalle público |
| **Perfil técnico** | `/profile`, `/application`, `/technician/documents` | Editar perfil, estado verificación, documentos |
| **Zona de servicio** | `/technician/service-area`, `/technician/service-area/map` | GPS, mapa con pin, radio 5/10/20 km |
| **Verificación** | `/technician/verification` | Checklist documentos + requisito de zona |
| **Cliente settings** | `/settings/client` | Configuración y promo "ser técnico" |
| **Admin** | `/admin/categories`, `/admin/applications` | CRUD categorías, revisar solicitudes |

Cambio de vista cliente ↔ técnico: barra superior del home (`AppView`).

---

## Permisos nativos

La app solicita en runtime:

| Permiso | Uso |
|---------|-----|
| Ubicación | Técnicos cercanos, zona de servicio, mapa |
| Cámara / galería | Foto de perfil, documentos, portfolio |
| Internet | API REST (implícito) |

Textos de permisos configurados en:
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

---

## Solución de problemas

### `JAVA_HOME is not set`

Configura JDK 17 de Android Studio antes de Gradle:

```powershell
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
```

### Mapa en gris / no carga

- Verifica `GOOGLE_MAPS_API_KEY` en `android/local.properties` o `Info.plist`
- Habilita Maps SDK en Google Cloud
- Restricciones de key: package + SHA-1 correctos
- **Hot restart** después de cambiar la key (no hot reload)

### Error de red / timeout

- Backend corriendo en puerto 3000
- URL correcta según emulador vs dispositivo físico
- Firewall de Windows permitiendo conexiones entrantes al backend

### Google Sign-In falla

- `GOOGLE_SERVER_CLIENT_ID` igual al del backend
- OAuth Android creado con SHA-1 y package `com.example.prueba`
- Emulador con Google Play Services

### Faltan archivos `*.g.dart`

```bash
dart run build_runner build --delete-conflicting-outputs
```

### `flutter analyze` con warnings en `app_router.g.dart`

Es normal en archivos generados; no editarlos a mano.

---

## Comandos útiles

```bash
# Dependencias
flutter pub get
flutter pub outdated

# Análisis estático
flutter analyze

# Tests
flutter test

# Limpiar build
flutter clean && flutter pub get

# Ver logs
flutter logs
```

---

## Contacto / entrega a nuevo dev

Checklist mínimo para compilar:

- [ ] Flutter 3.44+ y `flutter doctor` sin errores críticos
- [ ] Backend levantado
- [ ] `android/local.properties` creado (Android)
- [ ] API key de Google Maps configurada (Android + iOS si aplica)
- [ ] SHA-1 registrado en Google Cloud (Maps + Sign-In Android)
- [ ] `flutter pub get`
- [ ] `dart run build_runner build --delete-conflicting-outputs` *(si hace falta)*
- [ ] `flutter run`

Para dudas de API o credenciales compartidas, consultar al responsable del backend y del proyecto Google Cloud del equipo.
