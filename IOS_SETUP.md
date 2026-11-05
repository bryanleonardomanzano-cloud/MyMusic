# 📱 Configuración de MyMusic para iOS (iPhone)

Este documento describe los pasos necesarios para configurar y ejecutar MyMusic en dispositivos iOS (iPhone/iPad).

## 📋 Requisitos previos

- macOS con Xcode 14 o superior instalado
- Cuenta de Apple Developer (opcional, para dispositivo físico)
- Cuenta de Google Cloud Console (para Google Sign-In y Google Drive)

## 🔧 Configuración en Xcode

### 1. Abrir el proyecto en Xcode

```bash
cd C:\Users\hp_user\Desktop\Nueva carpeta (3)\MyMusic
open ios/Runner.xcworkspace
```

**Importante:** Siempre abre el archivo `.xcworkspace`, NO el `.xcodeproj`.

### 2. Configurar Bundle Identifier

En Xcode:
1. Selecciona el proyecto `Runner` en el navegador de archivos (izquierda)
2. Selecciona el target `Runner`
3. Ve a la pestaña **General**
4. Cambia `Bundle Identifier` a tu identificador único, por ejemplo:
   ```
   com.tuempresa.mymusic
   ```

### 3. Configurar Google Sign-In

Para que Google Sign-In funcione en iOS, necesitas:

#### 3.1 Crear un proyecto en Google Cloud Console
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la API de Google Drive API y Google Sign-In API
4. Crea credenciales de tipo **ID de cliente de OAuth 2.0**
   - Tipo de aplicación: iOS
   - Asigna un nombre (ej: "MyMusic iOS")
5. Anota el **ID de cliente de iOS** y el **ID de cliente invertido (REVERSED_CLIENT_ID)**

#### 3.2 Descargar GoogleService-Info.plist
1. En Google Cloud Console, descarga el archivo `GoogleService-Info.plist`
2. Arrastra este archivo a la carpeta `ios/Runner` en Xcode
3. Asegúrate de marcar "Copy items if needed" y seleccionar el target "Runner"

#### 3.3 Configurar URL Scheme en Info.plist
El archivo `Info.plist` ya incluye la clave `LSApplicationQueriesSchemes`, pero necesitas agregar el **REVERSED_CLIENT_ID` específico de tu proyecto:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.tuempresa.mymusic</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.TU_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Reemplaza `TU_REVERSED_CLIENT_ID` con el valor real de tu proyecto (se encuentra en el archivo GoogleService-Info.plist descargado).

### 4. Configurar permisos de iOS

El archivo `Info.plist` ya incluye los siguientes permisos:
- `NSMicrophoneUsageDescription` - Acceso al micrófono
- `NSPhotoLibraryUsageDescription` - Acceso a biblioteca de fotos
- `NSMusicLibraryUsageDescription` - Acceso a biblioteca de música
- `NSLocationWhenInUseUsageDescription` - Ubicación durante el uso
- `NSLocationAlwaysAndWhenInUseUsageDescription` - Ubicación siempre
- `NSFaceIDUsageDescription` - Autenticación Face ID

### 5. Configurar Capabilities (Capacidades)

En Xcode, ve a la pestaña **Signing & Capabilities** del target Runner:

1. Añade la capacidad **App Groups** (si planeas compartir datos entre extensiones)
2. Añade la capacidad **Background Modes** si necesitas reproducción de audio en segundo plano:
   - Marca "Audio, AirPlay, and Picture in Picture"
3. Configura **Signing**:
   - Selecciona tu equipo de desarrollo (Team)
   - Xcode generará automáticamente los certificados y perfiles

### 6. Configurar versión de iOS

En la pestaña **General** del target Runner:
- **Deployment Target**: iOS 14.0 o superior (recomendado iOS 15.0+)
- **Device**: iPhone

## 📦 Construir y ejecutar en iPhone

### 1. Conectar iPhone
Conecta tu iPhone al Mac mediante cable USB.

### 2. Seleccionar dispositivo
En Xcode, selecciona tu iPhone desde el desplegable de dispositivos (parte superior izquierda).

### 3. Ejecutar la aplicación
Presiona el botón ▶️ (Run) en Xcode o ejecuta desde terminal:

```bash
cd C:\Users\hp_user\Desktop\Nueva carpeta (3)\MyMusic
flutter run -d ios
```

O para un dispositivo específico:
```bash
flutter run -d <device_id>
```

## 🔧 Solución de problemas comunes

### Error: "Code signing is required for product type 'Application'"
- Ve a Signing & Capabilities y selecciona un equipo (Team)
- Si no tienes Apple Developer ID, usa "Personal Team" para pruebas en simulador

### Error: Google Sign-In no funciona
- Verifica que el `GoogleService-Info.plist` esté añadido al proyecto
- Verifica que el `REVERSED_CLIENT_ID` esté en el `Info.plist` como URL Scheme
- Verifica que la API de Google Drive y Google Sign-In estén habilitadas en Google Cloud Console

### Error: "No provisioning profile found"
- Ve a Signing & Capabilities
- Selecciona "Automatically manage signing"
- Elige tu equipo de desarrollo

### Error de compilación en iOS
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run -d ios
```

## 📱 Funcionalidades listas para iPhone

- ✅ Reproducción de música local (just_audio)
- ✅ Autenticación con Google (Google Sign-In)
- ✅ Almacenamiento de archivos descargados (offline)
- ✅ Lectura de metadatos ID3 de archivos MP3
- ✅ Búsqueda en Google Drive
- ✅ Navegación entre módulos (UI Shell)
- ✅ Gestión de biblioteca y playlists

## 📝 Notas adicionales

- La aplicación usa **Riverpod** para gestión de estado
- El almacenamiento local usa **shared_preferences** y **sqflite**
- La reproducción de audio usa **just_audio**
- La autenticación usa **google_sign_in**
- La integración con Google Drive usa **googleapis** y **googleapis_auth**

---

**Fecha de configuración:** 05 de noviembre de 2026  
**Versión del proyecto:** 1.0.0+1