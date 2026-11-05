# 05 — Estrategia de pruebas

## Pirámide
1. **Unitarias (70%)** — Dart puro, sin Flutter: mappers, `Result`, `ScanProgress`, búsqueda con normalización, repositorio en memoria, backoff, checksum descarga.
2. **Integración (20%)** — SQLite in-memory (`sqflite_common_ffi` con `databaseFactoryFfiNoIsolate`), Drive fake (clase `FakeDriveDataSource`), descarga con HTTP stub en `MockClient`.
3. **Widget/E2E básicos (10%)** — smoke: login fake → scan fake → lista → play fake engine → playlist CRUD.

## Reglas
- Un test por contrato de interfaz: `FakeDriveScanner`, `FakeLibraryRepository`, `FakePlayerEngine`.
- Tests de concurrencia: cancelación de escaneo, reanudación de descarga (.part + Range), idempotencia de upsert por `fileId`.
- Tests de metadatos: archivo real mínimo MP3/OGG sin tags → fallback "Artista - Título" de nombre.
- Tests de Drive: paginación, `429/5xx` con backoff, archivos no-audio ignorados, `trashed=false`.
- CI futuro: `flutter test --coverage`, `flutter analyze`, golden tests para tema oscuro.

## Módulo y su foco de prueba
| Módulo | Tipo clave |
|--------|-----------|
| auth | token refresh, expirado, sign-out borra storage |
| drive_scanner | paginación, cancelación, incremental |
| metadata | tags ID3/Vorbis, fallback nombre archivo |
| library | CRUD, favoritos, índice search |
| player | cola, shuffle/repeat, next/prev en borde |
| offline | reanudar, quota LRU, storage lleno |
| playlists | orden, duplicados, borrar |
| search | tildes/mayúsculas, `Álbum`→`album` |
| core | Result/AppError, normalización texto |
