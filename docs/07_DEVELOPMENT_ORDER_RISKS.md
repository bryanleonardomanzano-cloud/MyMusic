# 07 — Orden de desarrollo y riesgos

## Orden recomendado (desarrollar y probar cada módulo antes del siguiente)

| Paso | Módulo | Entregable mínimo | Criterio de salida (prueba) |
|---|---|---|---|
| 0 | Scaffold | `flutter create` + pubspec aprobado + `flutter analyze` | App compila, doctor sin issues |
| 1 | M0 core | `Result`, `AppError`, logger, retry, DI | Tests unitarios de Result/backoff |
| 2 | M1 auth | signIn/signOut con `google_sign_in` (OAuth a configurar) | Fake session: refresh/expirado |
| 3 | M2 drive_scanner | `files.list` paginado, solo lectura | Fake paginación 3 páginas + cancelación |
| 4 | M3 metadata | tags + fallback nombre “Artista - Título” | Fixture MP3/OGG sin tags → fallback |
| 5 | M4 library | SQLite schema v1, upsert por `fileId`, favoritos | SQLite ffi in-memory CRUD |
| 6 | M5 player | cola + just_audio con Range headers | FakeEngine cola/shuffle/repeat |
| 7 | M6 offline | descarga .part reanudable + quota LRU | MockClient: interrupción→reanudar |
| 8 | M7 playlists + M8 search | CRUD listas, búsqueda normalizada | Tests orden/duplicados, tildes |
| 9 | M9 ui_shell | tema oscuro, go_router, pantallas | Widget smoke con fakes |

## Riesgos principales y mitigación

| Riesgo | Impacto | Mitigación (arquitectura) |
|---|---|---|
| Audio en segundo plano en Windows desktop limitado en Flutter | Backgroound no nativo Win | `PlayerEngine` abstracto; móvil: `audio_service`; Windows: `just_audio_windows`/`audioplayers` + docs de limitación |
| Drive `429`/cuotas y red inestable | Escaneo/descarga interrumpidos | Paginación, backoff 429/5xx, reanudación por rangos, reintento por `fileId` |
| Metadatos ausentes | Tracks “sin artista/álbum” | Fallback por nombre de archivo + UI muestra “Desconocido” sin bloquear |
| Token expirado / revocación | Login roto | Refresh en memoria + `flutter_secure_storage`, re-auth humano, nunca guardar contraseña |
| Regla “no modificar Drive” | Pérdida de datos si se usa scope amplio | Scope `drive.readonly` únicamente; prohibido `drive`/`drive.file`; tests que verifican que no haya llamadas PUT/DELETE |
| Archivos mixtos en Drive (no-audio, duplicados) | Ruido en biblioteca | Filtro MIME audio + `trashed=false`; upsert idempotente por `fileId`; poda de archivos desaparecidos |
| Almacenamiento lleno (offline) | Descargas fallan | Quota configurable + LRU + error `storage.full` tipado |
| Archivos enormes (MP3 largo) | Streaming lento | Stream por rangos, nunca descargar completo para reproducir |
| Dependencias con build nativo en Windows | Compilación frágil | `sqflite_common_ffi`, validar `flutter doctor` por paso; fijar versiones en pubspec |
| Alcance: no inventar OAuth | Bloquea M1 en real | M1 se prueba con fakes hasta que el usuario provea su proyecto Google Cloud |

## Decisiones técnicas registradas
- Riverpod (no Bloc/GetX): DI e interfaces testeables sin Flutter.
- SQLite local (no SharedPreferences para catálogo): búsquedas, relaciones artista/álbum, favoritos.
- `fileId` como clave estable (no ruta de Drive, que puede moverse).
- Descargas organizadas `artista/album/titulo.mp3` con nombre sanitizado, fuera de Drive.
