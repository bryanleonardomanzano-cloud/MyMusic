# 03 — Interfaces y comunicación entre módulos

## Repositorios (domain) — contratos
```dart
// auth
abstract class AuthRepository {
  Future<Result<Session>> signIn();          // Session {accessToken, refreshToken, email, expiresAt}
  Future<Result<void>> signOut();
  Stream<Session?> watchSession();
  String? get token; // en memoria, nunca persistido en disco plano
}

// drive_scanner
abstract class DriveScanner {
  Stream<ScanProgress> scan({
    required String accessToken,
    required Set<String> mimeFilter,
    bool incremental = true,
    bool recursive = true,
  }); // ScanProgress {files: List<DriveFileRef>, total, processed, skipped}
  Future<void> cancel();
}

// metadata
abstract class MetadataParser {
  Future<Result<ParsedMetadata>> parse({
    required String fileId,           // Drive id
    required Map<String,String> httpHeaders,
    int sampleBytes = 20 * 1024 * 1024,
  });
}
// ParsedMetadata {title, artist, album, genre, trackNumber, year, durationMs, coverBytes, status}

// library
abstract class LibraryRepository {
  Future<Result<void>> upsertTracks(List<Track> tracks);
  Future<Result<List<Track>>> listBy({ArtistId? artist, AlbumId? album, String? genre, bool favoritesOnly});
  Stream<List<Track>> watchAll();
  Future<Result<Track?>> byFileId(String fileId);
  Future<Result<void>> setFavorite(String fileId, bool fav);
  Future<Result<void>> deleteGoneFiles(Set<String> keepFileIds); // poda incremental
}

// player
abstract class PlayerEngine {
  Future<Result<void>> play(Track track);
  Future<Result<void>> playQueue(List<Track> queue, int startIndex);
  Future<void> pause(); Future<void> resume(); Future<void> seek(Duration pos);
  Future<void> next(); Future<void> previous();
  Stream<PlayerState> get state; // {status, position, duration, current, buffered}
  void setShuffle(bool); void setRepeat(RepeatMode);
}

// offline
abstract class OfflineStore {
  Future<Result<String>> download(Track track); // devuelve path local
  Future<Result<void>> cancel(String fileId);
  Stream<DownloadProgress> progress(String fileId);
  String? localPathFor(String fileId);
  Future<Result<void>> enforceQuota({required int maxBytes}); // LRU
  Future<Result<void>> remove(String fileId);
}

// playlists
abstract class PlaylistRepository {
  Future<Result<Playlist>> create(String name);
  Future<Result<List<Playlist>>> list();
  Future<Result<void>> addTracks(String playlistId, List<String> fileIds);
  Future<Result<void>> removeTrack(String playlistId, String fileId);
  Future<Result<void>> reorder(String playlistId, List<String> orderedFileIds);
  Stream<List<Playlist>> watchAll();
}

// search
abstract class SearchRepository {
  Future<Result<List<Track>>> search(String query, {SearchScope scope, int limit});
}
```

## Value objects y errores
- `Result<T> = Success(data) | Failure(AppError)` en `core/result.dart`.
- `AppError` códigos: `auth.*`, `network.*`, `drive.rateLimited`, `storage.full`, `player.*`, `metadata.*`.
- `Track { fileId (Drive), title, artist, album, genre, durationMs, mime, sizeBytes, modifiedTime, isFavorite, localPath?, coverBytes?, streamUrl? }` — `fileId` es la clave estable entre scans.

## Comunicación
- **Pub/Sub** por `StateNotifier/AsyncNotifier` + `Stream` para UI.
- **Eventos**: `LibraryChanged`, `DownloadCompleted`, `PlaybackQueueChanged` (Streams).
- **DI**: Riverpod providers, cada provider expone la interfaz, nunca la impl. concreta.
- **Nunca**: UI → SQLite directo, UI → Drive directo, inter-feature imports salvo vía `core` + interfaces.

## Seguridad (requisitos)
- Token solo en memoria + `flutter_secure_storage`.
- Scopes Drive: `drive.readonly` (lectura) y si se necesitan thumbs: `drive.metadata.readonly`. Prohibido `drive.file`/`drive` (escritura).
- Nunca loggear `accessToken`.

## Resiliencia
- Descargas: rangos HTTP con `Range: bytes=X-Y`, reanudación, reintento con backoff (3x, 2s→8s), verificación de tamaño.
- Streaming: header `Range` de Drive para evitar descargar el MP3 completo.
- Escaneo: paginación `pageSize 1000` + cursor, reintento ante 429/5xx, cancelación cooperativa.
