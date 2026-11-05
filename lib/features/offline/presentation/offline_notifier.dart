/// StateNotifier que maneja la lógica de descargas y archivos offline.
/// Emite instancias de [OfflineState].
library mymusic.features.offline.presentation.offline_notifier;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymusic/features/offline/data/offline_data_source.dart';
import 'package:mymusic/features/offline/domain/offline_state.dart';

/// StateNotifier que maneja el estado de descargas offline.
class OfflineNotifier extends StateNotifier<OfflineState> {
  final OfflineDataSource _dataSource;

  OfflineNotifier({required OfflineDataSource dataSource})
      : _dataSource = dataSource,
        super(OfflineState.initial);

  /// Cargar todas las canciones descargadas y descargas activas
  Future<void> loadOfflineLibrary() async {
    state = state.copyWith(isDownloading: true, error: null);

    try {
      final songs = await _dataSource.getDownloadedSongs();
      final activeDownloads = await _dataSource.getActiveDownloads();
      final pendingDownloads = await _dataSource.getPendingDownloads();

      state = state.copyWith(
        downloadedSongs: songs,
        activeDownloads: activeDownloads,
        pendingDownloads: pendingDownloads,
        isDownloading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        error: 'Error al cargar biblioteca offline: $e',
      );
    }
  }

  /// Descargar una canción para uso offline
  Future<void> downloadSong({
    required String songId,
    required String songTitle,
    required String songArtist,
    required String downloadUrl,
    required String localFilePath,
  }) async {
    try {
      await _dataSource.downloadSong(
        songId: songId,
        songTitle: songTitle,
        songArtist: songArtist,
        downloadUrl: downloadUrl,
        localFilePath: localFilePath,
      );

      // Recargar biblioteca para reflejar cambios
      await loadOfflineLibrary();
    } catch (e) {
      state = state.copyWith(error: 'Error al descargar canción: $e');
    }
  }

  /// Cancelar una descarga en progreso
  Future<void> cancelDownload(String downloadId) async {
    try {
      await _dataSource.cancelDownload(downloadId);
      final downloads = await _dataSource.getActiveDownloads();
      state = state.copyWith(
        activeDownloads: downloads,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al cancelar descarga: $e');
    }
  }

  /// Eliminar una canción descargada
  Future<void> deleteDownloadedSong(String songId) async {
    try {
      await _dataSource.deleteDownloadedSong(songId);
      final updatedSongs =
          state.downloadedSongs.where((s) => s.id != songId).toList();
      state = state.copyWith(downloadedSongs: updatedSongs);
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar canción: $e');
    }
  }

  /// Pausar una descarga
  Future<void> pauseDownload(String downloadId) async {
    try {
      await _dataSource.pauseDownload(downloadId);
      final downloads = await _dataSource.getActiveDownloads();
      state = state.copyWith(
        activeDownloads: downloads,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al pausar descarga: $e');
    }
  }

  /// Reanudar una descarga pausada
  Future<void> resumeDownload(String downloadId) async {
    try {
      await _dataSource.resumeDownload(downloadId);
      final downloads = await _dataSource.getActiveDownloads();
      state = state.copyWith(
        activeDownloads: downloads,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al reanudar descarga: $e');
    }
  }

  /// Verificar si una canción está descargada
  Future<bool> isSongDownloaded(String songId) async {
    return await _dataSource.isSongDownloaded(songId);
  }

  /// Dispose recursos del data source
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
    super.dispose();
  }
}