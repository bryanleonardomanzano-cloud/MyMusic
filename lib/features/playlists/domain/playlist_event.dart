/// Eventos del módulo de Playlists.
library mymusic.features.playlists.domain.playlist_event;

/// Evento para crear una nueva playlist
class CreatePlaylist {
  final String name;
  final String? description;

  CreatePlaylist({required this.name, this.description});
}

/// Evento para eliminar una playlist
class DeletePlaylist {
  final String playlistId;

  DeletePlaylist({required this.playlistId});
}

/// Evento para agregar una canción a una playlist
class AddSongToPlaylist {
  final String playlistId;
  final String songId;

  AddSongToPlaylist({required this.playlistId, required this.songId});
}

/// Evento para eliminar una canción de una playlist
class RemoveSongFromPlaylist {
  final String playlistId;
  final String songId;

  RemoveSongFromPlaylist({required this.playlistId, required this.songId});
}

/// Evento para seleccionar una playlist
class SelectPlaylist {
  final String playlistId;

  SelectPlaylist({required this.playlistId});
}

/// Evento para renombrar una playlist
class RenamePlaylist {
  final String playlistId;
  final String newName;

  RenamePlaylist({required this.playlistId, required this.newName});
}

/// Evento para cargar todas las playlists
class LoadPlaylists {}