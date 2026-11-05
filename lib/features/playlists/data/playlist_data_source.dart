/// Data source interface para el módulo de Playlists.
/// Define el contrato para acceder a las playlists.
library mymusic.features.playlists.data.playlist_data_source;

import 'package:mymusic/features/playlists/domain/playlist_state.dart';

abstract class PlaylistDataSource {
  /// Obtener todas las playlists
  Future<List<Playlist>> getPlaylists();

  /// Crear una nueva playlist
  Future<void> createPlaylist(Playlist playlist);

  /// Eliminar una playlist
  Future<void> deletePlaylist(String playlistId);

  /// Agregar una canción a una playlist
  Future<void> addSongToPlaylist(String playlistId, String songId);

  /// Eliminar una canción de una playlist
  Future<void> removeSongFromPlaylist(String playlistId, String songId);

  /// Obtener una playlist por su ID
  Future<Playlist?> getPlaylist(String playlistId);

  /// Dispose recursos
  Future<void> dispose();
}