/// Eventos del módulo de biblioteca musical.
library mymusic.features.library.domain.library_event;

import 'library_state.dart';

/// Evento para agregar una canción a la biblioteca
class AddSong {
  final Song song;

  AddSong({required this.song});
}

/// Evento para eliminar una canción de la biblioteca
class RemoveSong {
  final String songId;

  RemoveSong({required this.songId});
}

/// Evento para crear una nueva playlist
class CreatePlaylist {
  final String name;
  final String? description;

  CreatePlaylist({required this.name, this.description});
}

/// Evento para agregar una canción a una playlist
class AddSongToPlaylist {
  final String playlistId;
  final String songId;

  AddSongToPlaylist({required this.playlistId, required this.songId});
}

/// Evento para seleccionar una canción en la biblioteca
class SelectSong {
  final String songId;

  SelectSong({required this.songId});
}

/// Evento para refrescar la biblioteca (recargar desde origen)
class RefreshLibrary {}