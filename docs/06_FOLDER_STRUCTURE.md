# 06 — Estructura completa de carpetas

```text
MyMusic/
├── pubspec.yaml                  # PROPUESTO (no validado con pub get)
├── README.md
├── docs/
│   ├── 00_OVERVIEW.md
│   ├── 01_ARCHITECTURE.md
│   ├── 02_MODULES.md
│   ├── 03_INTERFACES.md
│   ├── 04_PUBSPEC.md
│   ├── 05_TESTING_STRATEGY.md
│   ├── 06_FOLDER_STRUCTURE.md    # este archivo
│   ├── 07_DEVELOPMENT_ORDER_RISKS.md
│   └── 08_EXTENSIBILITY_VERIFICATION.md
├── assets/
│   ├── images/                   # placeholder / icono, sin assets finales
│   └── fonts/
├── lib/
│   ├── main.dart                 # skeleton de composición (no funcional)
│   ├── app/
│   │   └── app.dart              # MaterialApp.router + tema + DI raíz (skeleton)
│   ├── core/                     # M0 — transversal, sin negocio
│   │   ├── di/providers.dart     # providers Riverpod (exponen interfaces)
│   │   ├── errors/app_error.dart # AppError + Result<T>
│   │   ├── logging/app_logger.dart
│   │   ├── network/retry_policy.dart # backoff 3x 2s→8s, maneja 429/5xx/red
│   │   └── utils/text_utils.dart # normalización Unicode, fechas, duraciones
│   ├── features/
│   │   ├── auth/                 # M1
│   │   │   ├── domain/auth_repository.dart
│   │   │   ├── data/             # GoogleSignInDataSource, SecureTokenStore (futuro)
│   │   │   └── presentation/     # login screen, session notifier (futura)
│   │   ├── drive_scanner/        # M2
│   │   │   ├── domain/drive_scanner.dart
│   │   │   ├── data/             # DriveDataSource (googleapis), paginador (futuro)
│   │   │   └── presentation/     # progreso de escaneo (futura)
│   │   ├── metadata/             # M3
│   │   │   ├── domain/metadata_parser.dart
│   │   │   ├── data/             # ID3/Vorbis/MP4 + fallback nombre archivo (futuro)
│   │   │   └── presentation/     # (típicamente sin UI propia)
│   │   ├── library/              # M4
│   │   │   ├── domain/track.dart
│   │   │   ├── domain/library_repository.dart
│   │   │   ├── data/             # SQLite DAO, mappers, schema v1 (futuro)
│   │   │   └── presentation/     # biblioteca artista/album/genero (futura)
│   │   ├── player/               # M5
│   │   │   ├── domain/player_engine.dart
│   │   │   ├── data/             # just_audio + audio_service adapter (futuro)
│   │   │   └── presentation/     # now playing, cola, controles (futura)
│   │   ├── offline/              # M6
│   │   │   ├── domain/offline_store.dart
│   │   │   ├── data/             # Range resume .part, quota LRU (futuro)
│   │   │   └── presentation/     # descargas, storage (futura)
│   │   ├── playlists/            # M7
│   │   │   ├── domain/playlist_repository.dart
│   │   │   ├── data/             # DAO listas (futuro)
│   │   │   └── presentation/     # CRUD listas (futura)
│   │   ├── search/               # M8
│   │   │   ├── domain/search_repository.dart
│   │   │   ├── data/             # LIKE + normalización (futuro)
│   │   │   └── presentation/     # buscador UI (futura)
│   │   └── ui_shell/             # M9
│   │       ├── domain/app_routes.dart
│   │       └── presentation/     # shell, go_router, tema oscuro (futura)
│   ├── shared/
│   │   ├── theme/app_theme.dart  # tema oscuro modular
│   │   └── widgets/              # widgets reutilizables
│   └── data/platform/            # adaptadores Android/iOS/Windows (futuro)
└── test/
    ├── unit/                     # Dart puro
    ├── integration/              # SQLite ffi + fakes Drive/HTTP
    └── widget/                   # smoke con fakes
```

## Convenciones
- `domain/`: entidades + `abstract class` (interfaces). Nada de Flutter/SQL/Drive.
- `data/`: implementación + modelos `*Model` (fromMap/toMap). Solo aquí viven paquetes externos.
- `presentation/`: Widget + ViewModel/Notifier. Solo consume interfaces de `domain`.
- Un solo `fileId` (Drive) como identidad estable de `Track` entre escaneos.
