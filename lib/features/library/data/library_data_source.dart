/// Data source interface para el módulo de biblioteca.
/// Define el contrato para acceder a la colección de canciones y playlists.
library mymusic.features.library.data.library_data_source;

import 'package:mymusic/features/library/domain/library_state.dart';

abstract class LibraryDataSource {
  /// Obtener todas las canciones de la biblioteca
  Future<List<Song>> getSongs();

  /// Obtener todas las playlists
  Future<List<Playlist>> getPlaylists();

  /// Agregar una canción a la biblioteca
  Future<void> addSong(Song song);

  /// Eliminar una canción de la biblioteca
  Future<void> removeSong(String songId);

  /// Crear una nueva playlist
  Future<void> createPlaylist(Playlist playlist);

  /// Agregar una canción a una playlist
  Future<void> addSongToPlaylist(String playlistId, String songId);

  /// Eliminar una canción de una playlist
  Future<void> removeSongFromPlaylist(String playlistId, String songId);

  /// Buscar canciones en la biblioteca
  Future<List<Song>> searchSongs(String query);

  /// Dispose recursos
  Future<void> dispose();
}