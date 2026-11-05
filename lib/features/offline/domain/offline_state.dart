/// Estado del módulo Offline.
/// Contiene la información de descargas y canciones disponibles sin conexión.
library mymusic.features.offline.domain.offline_state;

/// Estado del módulo Offline.
class OfflineState {
  /// Lista de canciones disponibles offline (descargadas)
  final List<OfflineSong> downloadedSongs;

  /// Lista de descargas en progreso
  final List<DownloadTask> activeDownloads;

  /// Cola de descargas pendientes
  final List<DownloadTask> pendingDownloads;

  /// Indica si hay una descarga en curso
  final bool isDownloading;

  /// Mensaje de error si ocurrió uno
  final String? error;

  /// Constructor
  OfflineState({
    this.downloadedSongs = const [],
    this.activeDownloads = const [],
    this.pendingDownloads = const [],
    this.isDownloading = false,
    this.error,
  });

  /// Estado inicial vacío
  static final OfflineState initial = OfflineState();

  /// Crea una copia con campos actualizados
  OfflineState copyWith({
    List<OfflineSong>? downloadedSongs,
    List<DownloadTask>? activeDownloads,
    List<DownloadTask>? pendingDownloads,
    bool? isDownloading,
    String? error,
  }) {
    return OfflineState(
      downloadedSongs: downloadedSongs ?? this.downloadedSongs,
      activeDownloads: activeDownloads ?? this.activeDownloads,
      pendingDownloads: pendingDownloads ?? this.pendingDownloads,
      isDownloading: isDownloading ?? this.isDownloading,
      error: error ?? this.error,
    );
  }

  /// Cantidad total de canciones descargadas
  int get downloadedCount => downloadedSongs.length;

  /// Cantidad total de descargas activas
  int get activeDownloadCount => activeDownloads.length;

  /// Cantidad total de descargas pendientes
  int get pendingDownloadCount => pendingDownloads.length;

  @override
  String toString() {
    if (error != null) return 'OfflineState.error(message: $error)';
    if (isDownloading) return 'OfflineState.downloading';
    return 'OfflineState(downloaded: $downloadedCount, active: $activeDownloadCount, pending: $pendingDownloadCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OfflineState &&
        other.downloadedSongs == downloadedSongs &&
        other.activeDownloads == activeDownloads &&
        other.pendingDownloads == pendingDownloads &&
        other.isDownloading == isDownloading &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(downloadedSongs, activeDownloads, pendingDownloads, isDownloading, error);
}

/// Representa una canción descargada para uso offline
class OfflineSong {
  /// ID único de la canción
  final String id;

  /// Título de la canción
  final String title;

  /// Artista de la canción
  final String artist;

  /// Álbum de la canción (opcional)
  final String? album;

  /// Género musical (opcional)
  final String? genre;

  /// Duración en milisegundos
  final int durationMs;

  /// Ruta local del archivo descargado
  final String localFilePath;

  /// Fecha de descarga
  final DateTime downloadedAt;

  /// Tamaño del archivo en bytes
  final int fileSizeBytes;

  /// Constructor
  OfflineSong({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.genre,
    required this.durationMs,
    required this.localFilePath,
    required this.downloadedAt,
    required this.fileSizeBytes,
  });

  @override
  String toString() {
    return 'OfflineSong(title: $title, artist: $artist)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OfflineSong && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Representa una tarea de descarga en progreso
class DownloadTask {
  /// ID único de la tarea
  final String id;

  /// ID de la canción a descargar
  final String songId;

  /// Título de la canción
  final String songTitle;

  /// Artista de la canción
  final String songArtist;

  /// URL de descarga del archivo
  final String downloadUrl;

  /// Ruta local donde se guardará el archivo
  final String localFilePath;

  /// Progreso de descarga (0.0 a 1.0)
  final double progress;

  /// Estado de la descarga
  final DownloadStatus status;

  /// Fecha de inicio de la descarga
  final DateTime startedAt;

  /// Constructor
  DownloadTask({
    required this.id,
    required this.songId,
    required this.songTitle,
    required this.songArtist,
    required this.downloadUrl,
    required this.localFilePath,
    this.progress = 0.0,
    this.status = DownloadStatus.pending,
    required this.startedAt,
  });

  /// Crea una copia con campos actualizados
  DownloadTask copyWith({
    String? id,
    String? songId,
    String? songTitle,
    String? songArtist,
    String? downloadUrl,
    String? localFilePath,
    double? progress,
    DownloadStatus? status,
    DateTime? startedAt,
  }) {
    return DownloadTask(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      songTitle: songTitle ?? this.songTitle,
      songArtist: songArtist ?? this.songArtist,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      localFilePath: localFilePath ?? this.localFilePath,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  String toString() {
    return 'DownloadTask(song: $songTitle, progress: ${(progress * 100).toStringAsFixed(0)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DownloadTask && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Estados posibles de una descarga
enum DownloadStatus {
  pending,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}