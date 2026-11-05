/// StateNotifier que maneja la lógica de Playlists.
/// Emite instancias de [PlaylistState].
library mymusic.features.playlists.presentation.playlist_notifier;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymusic/features/playlists/data/playlist_data_source.dart';
import 'package:mymusic/features/playlists/domain/playlist_state.dart';

/// StateNotifier que maneja el estado de Playlists.
class PlaylistNotifier extends StateNotifier<PlaylistState> {
  final PlaylistDataSource _dataSource;

  PlaylistNotifier({required PlaylistDataSource dataSource})
      : _dataSource = dataSource,
        super(PlaylistState.initial);

  /// Cargar todas las playlists
  Future<void> loadPlaylists() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final playlists = await _dataSource.getPlaylists();
      state = state.copyWith(
        playlists: playlists,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar playlists: $e',
      );
    }
  }

  /// Crear una nueva playlist
  Future<void> createPlaylist(String name, {String? description}) async {
    try {
      final playlist = Playlist(
        id: 'playlist_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        songIds: [],
        createdAt: DateTime.now(),
      );
      await _dataSource.createPlaylist(playlist);
      final updatedPlaylists = [...state.playlists, playlist];
      state = state.copyWith(playlists: updatedPlaylists);
    } catch (e) {
      state = state.copyWith(error: 'Error al crear playlist: $e');
    }
  }

  /// Eliminar una playlist
  Future<void> deletePlaylist(String playlistId) async {
    try {
      await _dataSource.deletePlaylist(playlistId);
      final updatedPlaylists =
          state.playlists.where((p) => p.id != playlistId).toList();
      state = state.copyWith(
        playlists: updatedPlaylists,
        selectedPlaylist:
            state.selectedPlaylist?.id == playlistId ? null : state.selectedPlaylist,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar playlist: $e');
    }
  }

  /// Agregar una canción a una playlist
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    try {
      await _dataSource.addSongToPlaylist(playlistId, songId);
      final playlists = await _dataSource.getPlaylists();
      state = state.copyWith(playlists: playlists);
    } catch (e) {
      state = state.copyWith(error: 'Error al agregar a playlist: $e');
    }
  }

  /// Eliminar una canción de una playlist
  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    try {
      await _dataSource.removeSongFromPlaylist(playlistId, songId);
      final playlists = await _dataSource.getPlaylists();
      state = state.copyWith(playlists: playlists);
    } catch (e) {
      state = state.copyWith(error: 'Error al quitar de playlist: $e');
    }
  }

  /// Seleccionar una playlist
  Future<void> selectPlaylist(String playlistId) async {
    final playlist = state.playlists.firstWhere(
      (p) => p.id == playlistId,
      orElse: () => throw Exception('Playlist no encontrada'),
    );
    state = state.copyWith(selectedPlaylist: playlist);
  }

  /// Renombrar una playlist
  Future<void> renamePlaylist(String playlistId, String newName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      final updatedPlaylists = state.playlists.map((p) {
        if (p.id == playlistId) {
          return p.copyWith(name: newName);
        }
        return p;
      }).toList();
      state = state.copyWith(playlists: updatedPlaylists);
    } catch (e) {
      state = state.copyWith(error: 'Error al renombrar playlist: $e');
    }
  }

  /// Dispose recursos del data source
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
    super.dispose();
  }
}