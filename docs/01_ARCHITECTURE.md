# 01 — Arquitectura por capas

## Principios
1. **Dependencias hacia adentro**: Presentation → Application → Domain ← Data. Core atraviesa todo.
2. **Regla de dependencia**: `domain` no conoce Flutter, Drive, ni SQLite. Solo Dart puro.
3. **Feature-first**: una carpeta por funcionalidad (`features/auth`, `features/player`…), cada una con `domain/data/presentation`.
4. **SOLID**: repositorios como interfaces en domain, implementaciones en data.
5. **Interfaces antes que código**: ver `03_INTERFACES.md`.

## Vista por capas
```
+------------------------------------------------ Devuelve Widgets
|  PRESENTACIÓN (Flutter Widgets, Riverpod Notifiers, go_router)
|  - Pantallas por feature, widgets compartidos (app/widgets)
+------------------------------------------------
|  APLICACIÓN (UseCases orquestadores, Stream/AsyncValue, caché UI)
|  - ScanLibrary, PlayTrack, ToggleFavorite, CreatePlaylist, SearchTracks
+------------------------------------------------
|  DOMINIO (Entidades, Repositorios-interfaz, ValueObjects, Result<T>)
|  - Track, Album, Artist, Playlist, ScanState, PlaybackState
+------------------------------------------------
|  DATOS (Modelos Json/Map <-> Entidad, DataSources, Repositorios impl.)
|  - DriveDataSource (googleapis), LocalDb (sqflite), MetadataParser, OfflineStore
+------------------------------------------------
|  INFRA / CORE (Auth token, Logging, Errors, Network, DI, Theme, Utils)
|  Platform: Android / iOS / Windows (adapters en data/platform/)
+------------------------------------------------
      |   Solo accesos permitidos
      v
  Google Drive API v3 (solo lectura) + Filesystem local (descargas)
```

## Flujo típico (escaneo + reproducción)
```
UI -> ScanLibraryUseCase -> DriveRepository.scan() -> DriveDataSource.listAudio()
   -> MetadataParser -> LocalDb upsert (batch, incremental)
   -> LibraryRepository.watchTracks() -> UI Stream
Play: UI -> PlayTrackUseCase -> PlayerEngine.play(urlStream) -> just_audio (AudioSource.uri con Range headers)
```

## Manejo de errores / reintentos
- Todo resultado envuelto en `Result<T> = Success<T> | Failure(AppError)`.
- Errores: `AuthExpired, NetworkUnavailable, DriveRateLimit, NotFound, StorageFull, PlayerError, MetadataMissing`.
- Backoff exponencial + reanudar descarga por rangos (ver módulo offline).

## Extensibilidad
- Nueva fuente de música (local, YouTube): nuevo `DataSource` sin tocar domain.
- Nuevo motor de audio: adaptar `PlayerEngine` interface.
- Nuevo tipo de almacenamiento: otro `LibraryRepository`.
