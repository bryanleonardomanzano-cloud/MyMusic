/// Repositorio implementa [PlaylistDataSource].
/// Entrega instancias de [Playlist] desde la biblioteca.
/// Esta versión usa datos simulados (mock); la implementación completa
/// integrará con Google Drive o una base de datos local SQLite.
library mymusic.features.playlists.data.playlist_repository;

import 'package:mymusic/features/playlists/data/playlist_data_source.dart';
import 'package:mymusic/features/playlists/domain/playlist_state.dart';

class PlaylistRepository implements PlaylistDataSource {
  /// Playlists simuladas
  final List<Playlist> _mockPlaylists = [
    Playlist(
      id: 'playlist_001',
      name: 'Mis Favoritas',
      description: 'Las mejores canciones',
      songIds: ['song_001', 'song_003'],
      createdAt: DateTime(2024, 1, 20),
    ),
    Playlist(
      id: 'playlist_002',
      name: 'Para Ejercitarme',
      description: 'Música con energía',
      songIds: ['song_004'],
      createdAt: DateTime(2024, 2, 10),
    ),
    Playlist(
      id: 'playlist_003',
      name: 'Relax',
      description: 'Música relajante',
      songIds: ['song_003', 'song_005'],
      createdAt: DateTime(2024, 3, 15),
    ),
  ];

  @override
  Future<List<Playlist>> getPlaylists() async {
    // Simular latencia de red/disco
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_mockPlaylists);
  }

  @override
  Future<void> createPlaylist(Playlist playlist) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockPlaylists.add(playlist);
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockPlaylists.removeWhere((p) => p.id == playlistId);
  }

  @override
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final playlistIndex = _mockPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex != -1) {
      final playlist = _mockPlaylists[playlistIndex];
      if (!playlist.songIds.contains(songId)) {
        _mockPlaylists[playlistIndex] = playlist.copyWith(
          songIds: [...playlist.songIds, songId],
        );
      }
    }
  }

  @override
  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final playlistIndex = _mockPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex != -1) {
      final playlist = _mockPlaylists[playlistIndex];
      _mockPlaylists[playlistIndex] = playlist.copyWith(
        songIds: playlist.songIds.where((id) => id != songId).toList(),
      );
    }
  }

  @override
  Future<Playlist?> getPlaylist(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockPlaylists.firstWhere((p) => p.id == playlistId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> dispose() async {
    // No hay recursos que liberar en esta implementación mock
  }
}