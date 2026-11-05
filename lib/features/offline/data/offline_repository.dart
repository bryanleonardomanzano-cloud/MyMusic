/// Repositorio implementa [OfflineDataSource].
/// Gestiona descargas y archivos offline con datos simulados.
library mymusic.features.offline.data.offline_repository;

import 'dart:async';

import 'package:mymusic/features/offline/data/offline_data_source.dart';
import 'package:mymusic/features/offline/domain/offline_state.dart';

/// Implementación de [OfflineDataSource] con datos simulados.
/// En una implementación real, se conectaría con el sistema de archivos
/// local y una librería de descarga como dio o http.
class OfflineRepository implements OfflineDataSource {
  /// Canciones simuladas descargadas
  final List<OfflineSong> _mockDownloadedSongs = [
    OfflineSong(
      id: 'song_001',
      title: 'Mi canción favorita',
      artist: 'Artista Uno',
      album: 'Álbum Principal',
      genre: 'Pop',
      durationMs: 240000,
      localFilePath: '/storage/emulated/0/MyMusic/songs/song_001.mp3',
      downloadedAt: DateTime(2024, 1, 15),
      fileSizeBytes: 4500000,
    ),
    OfflineSong(
      id: 'song_003',
      title: 'Balada romántica',
      artist: 'Artista Tres',
      album: 'Amor y Pasión',
      genre: 'Balada',
      durationMs: 300000,
      localFilePath: '/storage/emulated/0/MyMusic/songs/song_003.mp3',
      downloadedAt: DateTime(2024, 3, 10),
      fileSizeBytes: 5200000,
    ),
    OfflineSong(
      id: 'song_005',
      title: 'Jazz nocturno',
      artist: 'Músico Jazz',
      album: 'Noches de Jazz',
      genre: 'Jazz',
      durationMs: 270000,
      localFilePath: '/storage/emulated/0/MyMusic/songs/song_005.mp3',
      downloadedAt: DateTime(2024, 5, 12),
      fileSizeBytes: 3800000,
    ),
  ];

  /// Descargas simuladas en progreso
  final List<DownloadTask> _mockDownloads = [
    DownloadTask(
      id: 'download_001',
      songId: 'song_002',
      songTitle: 'Canción de verano',
      songArtist: 'Artista Dos',
      downloadUrl: 'https://example.com/music/song_002.mp3',
      localFilePath: '/storage/emulated/0/MyMusic/songs/song_002.mp3',
      progress: 0.45,
      status: DownloadStatus.downloading,
      startedAt: DateTime.now(),
    ),
    DownloadTask(
      id: 'download_002',
      songId: 'song_004',
      songTitle: 'Rock energético',
      songArtist: 'Banda Roca',
      downloadUrl: 'https://example.com/music/song_004.mp3',
      localFilePath: '/storage/emulated/0/MyMusic/songs/song_004.mp3',
      progress: 0.0,
      status: DownloadStatus.pending,
      startedAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<OfflineSong>> getDownloadedSongs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_mockDownloadedSongs);
  }

  @override
  Future<List<DownloadTask>> getActiveDownloads() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDownloads.where((d) =>
        d.status != DownloadStatus.completed &&
        d.status != DownloadStatus.cancelled &&
        d.status != DownloadStatus.failed).toList();
  }

  @override
  Future<List<DownloadTask>> getPendingDownloads() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDownloads.where((d) => d.status == DownloadStatus.pending).toList();
  }

  @override
  Future<void> downloadSong({
    required String songId,
    required String songTitle,
    required String songArtist,
    required String downloadUrl,
    required String localFilePath,
  }) async {
    final downloadId = 'download_${DateTime.now().millisecondsSinceEpoch}';
    final task = DownloadTask(
      id: downloadId,
      songId: songId,
      songTitle: songTitle,
      songArtist: songArtist,
      downloadUrl: downloadUrl,
      localFilePath: localFilePath,
      progress: 0.0,
      status: DownloadStatus.downloading,
      startedAt: DateTime.now(),
    );
    _mockDownloads.add(task);

    // Simular progreso de descarga
    for (int i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      final updatedTask = task.copyWith(
        progress: i / 100,
        status: i == 100 ? DownloadStatus.completed : DownloadStatus.downloading,
      );
      _mockDownloads[_mockDownloads.indexWhere((t) => t.id == downloadId)] = updatedTask;
    }

    // Cuando termina, agregar a canciones descargadas
    _mockDownloadedSongs.add(OfflineSong(
      id: songId,
      title: songTitle,
      artist: songArtist,
      durationMs: 0,
      localFilePath: localFilePath,
      downloadedAt: DateTime.now(),
      fileSizeBytes: 0,
    ));
  }

  @override
  Future<void> cancelDownload(String downloadId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final taskIndex = _mockDownloads.indexWhere((d) => d.id == downloadId);
    if (taskIndex != -1) {
      _mockDownloads[taskIndex] = _mockDownloads[taskIndex].copyWith(
        status: DownloadStatus.cancelled,
      );
    }
  }

  @override
  Future<void> deleteDownloadedSong(String songId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockDownloadedSongs.removeWhere((s) => s.id == songId);
  }

  @override
  Future<void> pauseDownload(String downloadId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final taskIndex = _mockDownloads.indexWhere((d) => d.id == downloadId);
    if (taskIndex != -1) {
      _mockDownloads[taskIndex] = _mockDownloads[taskIndex].copyWith(
        status: DownloadStatus.paused,
      );
    }
  }

  @override
  Future<void> resumeDownload(String downloadId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final taskIndex = _mockDownloads.indexWhere((d) => d.id == downloadId);
    if (taskIndex != -1) {
      _mockDownloads[taskIndex] = _mockDownloads[taskIndex].copyWith(
        status: DownloadStatus.downloading,
      );
    }
  }

  @override
  Future<bool> isSongDownloaded(String songId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockDownloadedSongs.any((s) => s.id == songId);
  }

  @override
  Future<void> dispose() async {
    // No hay recursos que liberar en esta implementación mock
  }
}