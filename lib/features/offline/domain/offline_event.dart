/// Eventos del módulo Offline.
library mymusic.features.offline.domain.offline_event;

/// Evento para iniciar la descarga de una canción
class DownloadSong {
  final String songId;
  final String songTitle;
  final String songArtist;
  final String downloadUrl;
  final String localFilePath;

  DownloadSong({
    required this.songId,
    required this.songTitle,
    required this.songArtist,
    required this.downloadUrl,
    required this.localFilePath,
  });
}

/// Evento para cancelar una descarga en progreso
class CancelDownload {
  final String downloadId;

  CancelDownload({required this.downloadId});
}

/// Evento para eliminar una canción descargada
class DeleteDownloadedSong {
  final String songId;

  DeleteDownloadedSong({required this.songId});
}

/// Evento para pausar una descarga
class PauseDownload {
  final String downloadId;

  PauseDownload({required this.downloadId});
}

/// Evento para reanudar una descarga pausada
class ResumeDownload {
  final String downloadId;

  ResumeDownload({required this.downloadId});
}

/// Evento para cargar todas las descargas y canciones offline
class LoadOfflineLibrary {}