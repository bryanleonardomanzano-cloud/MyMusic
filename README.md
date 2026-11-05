# MyMusic

Reproductor musical privado tipo Spotify con catálogo exclusivo de Google Drive.
Plataformas: Android, iOS y Windows. Flutter + Dart.

## Estado actual: ARQUITECTURA (sin código funcional)

No hay `main` funcional, ni OAuth configurado, ni `flutter create` ejecutado.
Esta carpeta contiene la arquitectura modular y la documentación para desarrollar
cada módulo y probarlo antes de continuar con el siguiente.

## Documentación

- `docs/00_OVERVIEW.md` — objetivo y alcance
- `docs/01_ARCHITECTURE.md` — arquitectura por capas (Clean Architecture, feature-first)
- `docs/02_MODULES.md` — módulos M0–M9 y responsabilidades
- `docs/03_INTERFACES.md` — contratos entre módulos (repositorios, Result, errores)
- `docs/04_PUBSPEC.md` — dependencias propuestas y justificación
- `docs/05_TESTING_STRATEGY.md` — pirámide de pruebas y falsos (fakes)
- `docs/06_FOLDER_STRUCTURE.md` — estructura completa de carpetas
- `docs/07_DEVELOPMENT_ORDER_RISKS.md` — orden de desarrollo, criterios de salida y riesgos
- `docs/08_EXTENSIBILITY_VERIFICATION.md` — verificación de extensibilidad

## Estructura (resumen)

```text
lib/
  app/            # composición raíz (skeleton, no funcional)
  core/           # M0: di, errors, logging, network, utils
  features/       # M1–M9, cada una con domain/ data/ presentation/
  shared/         # widgets y tema compartidos
  data/platform/  # adaptadores por plataforma (Android/iOS/Windows)
docs/  test/{unit,integration,widget}/  assets/
```

## Reglas duras

- Google Drive es SOLO LECTURA: nunca modificar ni eliminar archivos (scope `drive.readonly`).
- No guardar contraseñas. Token solo en memoria + `flutter_secure_storage`.
- Sin servicios de pago ni backend. Todo el catálogo viene de Drive vía `fileId`/`accessToken`.

## Próximo paso propuesto (requiere tu aprobación)

1. `flutter create` sobre esta estructura y `flutter pub get` con el pubspec propuesto.
2. Desarrollar en orden: `core` → `auth` → `drive_scanner` → `metadata` → `library` → `player` → `offline` → `playlists`/`search` → `ui_shell`, probando cada módulo.
3. Recién después, configurar OAuth de Google Cloud (no hecho en esta fase).
