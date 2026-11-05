/// StateNotifier que maneja la lógica de la biblioteca musical.
/// Emite instancias de [LibraryState].
library mymusic.features.library.presentation.library_notifier;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymusic/features/library/data/library_data_source.dart';
import 'package:mymusic/features/library/domain/library_state.dart';

/// StateNotifier que maneja el estado de la biblioteca.
class LibraryNotifier extends StateNotifier<LibraryState> {
  final LibraryDataSource _dataSource;

  LibraryNotifier({required LibraryDataSource dataSource})
      : _dataSource = dataSource,
        super(LibraryState.initial);

  /// Cargar todas las canciones y playlists de la biblioteca
  Future<void> loadLibrary() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final songs = await _dataSource.getSongs();
      final playlists = await _dataSource.getPlaylists();

      state = state.copyWith(
        songs: songs,
        playlists: playlists,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar la biblioteca: $e',
      );
    }
  }

  /// Agregar una canción a la biblioteca
  Future<void> addSong(Song song) async {
    try {
      await _dataSource.addSong(song);
      final updatedSongs = [...state.songs, song];
      state = state.copyWith(songs: updatedSongs);
    } catch (e) {
      state = state.copyWith(error: 'Error al agregar canción: $e');
    }
  }

  /// Eliminar una canción de la biblioteca
  Future<void> removeSong(String songId) async {
    try {
      await _dataSource.removeSong(songId);
      final updatedSongs = state.songs.where((s) => s.id != songId).toList();
      state = state.copyWith(songs: updatedSongs);
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar canción: $e');
    }
  }

  /// Crear una nueva playlist
  Future<void> createPlaylist(String name, {String? description}) async {
    try {
      final playlist = Playlist(
        id: 'playlist_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      await _dataSource.createPlaylist(playlist);
      final updatedPlaylists = [...state.playlists, playlist];
      state = state.copyWith(playlists: updatedPlaylists);
    } catch (e) {
      state = state.copyWith(error: 'Error al crear playlist: $e');
    }
  }

  /// Agregar una canción a una playlist
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    try {
      await _dataSource.addSongToPlaylist(playlistId, songId);
      // Recargar playlists para reflejar cambios
      final playlists = await _dataSource.getPlaylists();
      state = state.copyWith(playlists: playlists);
    } catch (e) {
      state = state.copyWith(error: 'Error al agregar a playlist: $e');
    }
  }

  /// Seleccionar una canción
  Future<void> selectSong(String songId) async {
    final song = state.songs.firstWhere(
      (s) => s.id == songId,
      orElse: () => throw Exception('Canción no encontrada'),
    );
    state = state.copyWith(selectedSong: song);
  }

  /// Buscar canciones en la biblioteca
  Future<List<Song>> searchSongs(String query) async {
    if (query.isEmpty) {
      return state.songs;
    }
    return await _dataSource.searchSongs(query);
  }

  /// Dispose recursos del data source
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
    super.dispose();
  }
}