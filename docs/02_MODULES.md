# 02 — Módulos independientes

Cada módulo cumple: responsabilidad única, interfaz pública clara, tests propios, dependencia solo por interfaces.

| # | Módulo | Responsabilidad | Entidades clave | No hace |
|---|--------|-----------------|-----------------|---------|
| M1 | **auth** | Google Sign-In, tokens, refresh, sign-out, persistencia segura | AuthSession, SignInResult | No toca Drive ni UI de biblioteca |
| M2 | **drive_scanner** | Listar todo Drive (paginación, filtro MIME audio), progreso, cancelación, incremental | ScanJob, ScanProgress, DriveFileRef | No modifica Drive, no reproduce |
| M3 | **metadata** | Extraer ID3/Vorbis/MP4 tags; fallback: "Artista - Título" del nombre de archivo; arte (cover) | TrackMetadata, ParseStatus | No descarga el archivo completo |
| M4 | **library** | Persistencia local (SQLite): tracks, albums, artists, genres + queries organizadas, favoritos, índice de búsqueda | Track, Album, Artist | No conoce Drive |
| M5 | **player** | Cola, play/pause/next/prev, shuffle/repeat, background, notificaciones, stream desde Drive u offline | PlaybackState, QueueItem | No escanea |
| M6 | **offline** | Descargar por rangos con reanudación, organizar `artista/album/titulo.mp3`, LRU/quota | DownloadTask, OfflineFile | No reproduce directamente, expone `fileId -> path` |
| M7 | **playlists** | CRUD local de listas, orden, duplicar, exportar lista | Playlist, PlaylistTrack | No sube nada a Drive |
| M8 | **search** | Buscador local (LIKE, normalización Unicode), filtros por artista/álbum/género | SearchQuery, SearchResult | No hace búsquedas en red |
| M9 | **ui_shell** | Tema oscuro, navegación (`go_router`), shell (bottom bar / rail), pantallas | AppRoutes, AppTheme | No lógica de negocio |
| M0 | **core** | DI, errores, logging, red, UUID/fechas, utils texto/audio | AppError, Result, logger | Nada de negocio |

## Reglas entre módulos
- `player` y `offline` y `library` leen `Track` del dominio (mismo tipo).
- `drive_scanner` depende de `metadata` + `library` vía interfaces.
- `search` vive sobre `library` (repositorio), nunca directo a SQLite.
- UI importa solo `domain+presentation` de cada feature, nunca `data` internos.

## Orden de desarrollo recomendado
1. `core` → `auth` → 2. `drive_scanner` → 3. `metadata` → 4. `library` → 5. `player` → 6. `offline` → 7. `playlists/search` → 8. `ui_shell`
