# 04 — pubspec.yaml propuesto (sin ejecutar aún)

## Dependencias base
```yaml
name: mymusic
description: Reproductor musical privado desde Google Drive
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.13.0
  flutter: '>=3.47.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8        # iconos base Apple
  flutter_riverpod: ^2.5.1       # DI + estado reactive modular
  go_router: ^14.6.0             # navegación declarativa shell / playlists / biblioteca
  google_sign_in: ^6.2.1         # login Google -> AccessToken
  googleapis: ^11.3.0            # Drive API v3 tipada (files.list/get/download)
  http: ^1.2.1                   # rangos/streaming, reintentos
  just_audio: ^0.9.35            # motor de reproducción (streaming por URI + headers)
  audio_service: ^0.18.12        # background + notificaciones (Android/iOS); Windows: integración parcial (Rust)
  audioplayers: ^6.1.0           # fallback desktop Windows si audio_service no cubre
  sqflite: ^2.3.0                # persistencia local móvil
  sqflite_common_ffi: ^2.3.0     # Windows desktop compatible
  path_provider: ^2.1.4          # rutas documents/downloads para offline
  path: ^1.9.0                   # manipulación rutas multiplataforma
  flutter_secure_storage: ^9.0.4 # refresh token
  uuid: ^4.4.0                   # IDs locales estables
  intl: ^0.19.0                  # formato fechas/duraciones
  mime: ^2.0.0                   # detecta audio por extensión/MIME

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  mockito: ^5.4.4                # mocks de repositorios/datasources
  build_runner: ^2.4.0
  riverpod_test: ^1.0.0
```

## Justificación resumida
- **Riverpod**: alta modularidad, testeable sin Flutter, DI de interfaces.
- **go_router**: navegación por rutas que coincide con features.
- **google_sign_in + googleapis**: OAuth + Drive solo lectura, sin backend.
- **just_audio + audio_service**: streaming con Range headers + background real en móvil. Windows desktop: `just_audio` con `just_audio_windows` (VLC) y ventana de limitación documentada en Riesgos.
- **sqflite + sqflite_common_ffi**: una sola API local para Android/iOS/Windows.
- **path_provider + path**: offline organizado por artista/album.
- **flutter_secure_storage**: credenciales sin texto plano.
- **Posibles additions later**: `share_plus` (compartir lista), `share_plus`, `on_audio_query` NO (solo Android), `file_picker` (import local opcional), `workmanager` (escaneo periódico), `cached_network_image` (covers Drive thumbs), `logger`/`talker` (logs), `freezed/json_serializable` (modelos).

## Restricciones
- Cada dependencia debe justificarse en el módulo que la usa; prohibido agregar paquetes sin actualizar este documento.
