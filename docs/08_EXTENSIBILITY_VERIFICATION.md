# 08 — Extensibilidad y verificación de la arquitectura

## Checklist de verificación (cada punto debe ser verdadero antes de codificar)

- [x] 1. Capas definidas y dependencias hacia adentro (`01_ARCHITECTURE.md`).
- [x] 2. Módulos M0–M9 independientes con responsabilidad única (`02_MODULES.md`).
- [x] 3. Estructura de carpetas completa y convencional (`06_FOLDER_STRUCTURE.md`).
- [x] 4. Dependencias propuestas con justificación por módulo (`04_PUBSPEC.md`).
- [x] 5. Interfaces y comunicación documentadas: repositorios, `Result<T>`, `AppError`, Streams/eventos (`03_INTERFACES.md`).
- [x] 6. Estrategia de pruebas con fakes y pirámide 70/20/10 (`05_TESTING_STRATEGY.md`).
- [x] 7. Orden de desarrollo con criterios de salida y riesgos (`07_DEVELOPMENT_ORDER_RISKS.md`).
- [ ] 8. OAuth: NO configurado en esta fase por requisito explícito (paso 2 del roadmap).
- [ ] 9. Código funcional: NO iniciado en esta fase por requisito explícito.

## Escenarios de ampliación sin reconstruir

| Ampliación futura | Cómo encaja sin romper |
|---|---|
| Nueva fuente (carpeta local, NAS, otra nube) | Nuevo `DataSource` que produzca `DriveFileRef`/`Track` + mismo `LibraryRepository` |
| Nuevo motor de audio | Nuevo adapter de `PlayerEngine`; UI y use cases no cambian |
| Nuevas plataformas (Linux/macOS/Web) | Nuevo adapter en `data/platform/`; domain intacto |
| Carátulas desde Drive thumbs | `MetadataParser` + campo `coverBytes` ya previsto en `Track` |
| Escaneo periódico automático | `workmanager` (futura) llamando a `DriveScanner` existente |
| Compartir/exportar playlist | Nuevo `PlaylistExporter` en M7 usando `PlaylistRepository` |
| Historial de reproducción / estadísticas | Nueva tabla + repo en M4, sin tocar Drive |
| Multi-cuenta Google | `AuthRepository.watchSession` ya emite `Session?`; extender a lista de sesiones |

## Reglas que protegen la ampliación
1. Nada de imports de `data/` desde `presentation/` (solo interfaces de `domain/`).
2. Nada de imports de Drive/SQLite desde `domain/`.
3. Toda dependencia nueva en `pubspec.yaml` debe justificarse en `04_PUBSPEC.md`.
4. Toda funcionalidad nueva es una carpeta `features/<nueva>` con su `domain/data/presentation`.
5. `fileId` sigue siendo la identidad estable; cualquier migración de DB debe preservar favoritos/playlists por `fileId`.

## Informe de esta fase (verificado el día de creación)

- Archivos creados en esta fase: **9** (`README.md`, `pubspec.yaml`, `docs/00–08` menos 06–08 contados aquí; total docs = 9 archivos `.md` + README + pubspec).
- Código funcional: **0** (solo stubs `abstract class` en `lib/` marcados como no funcionales).
- Errores/bloqueos: ninguno en la fase de arquitectura; quedan pendientes OAuth y `flutter create`/`pub get` por diseño.
