/// Data source interface para el módulo Offline.
/// Define el contrato para gestionar descargas y archivos offline.
library mymusic.features.offline.data.offline_data_source;

import 'package:mymusic/features/offline/domain/offline_state.dart';

abstract class OfflineDataSource {
  /// Obtener todas las canciones descargadas
  Future<List<OfflineSong>> getDownloadedSongs();

  /// Obtener todas las descargas activas y pendientes
  Future<List<DownloadTask>> getActiveDownloads();

  /// Obtener todas las descargas pendientes
  Future<List<DownloadTask>> getPendingDownloads();

  /// Descargar una canción para uso offline
  Future<void> downloadSong({
    required String songId,
    required String songTitle,
    required String songArtist,
    required String downloadUrl,
    required String localFilePath,
  });

  /// Cancelar una descarga en progreso
  Future<void> cancelDownload(String downloadId);

  /// Eliminar una canción descargada
  Future<void> deleteDownloadedSong(String songId);

  /// Pausar una descarga
  Future<void> pauseDownload(String downloadId);

  /// Reanudar una descarga pausada
  Future<void> resumeDownload(String downloadId);

  /// Verificar si una canción está descargada
  Future<bool> isSongDownloaded(String songId);

  /// Dispose recursos
  Future<void> dispose();
}