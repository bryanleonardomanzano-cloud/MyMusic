/// Estado del módulo de biblioteca musical.
/// Contiene la colección de canciones y playlists del usuario.
library mymusic.features.library.domain.library_state;

/// Estado de la biblioteca musical.
class LibraryState {
  /// Lista de canciones en la biblioteca
  final List<Song> songs;

  /// Lista de playlists
  final List<Playlist> playlists;

  /// Canción actualmente seleccionada
  final Song? selectedSong;

  /// Indica si se está cargando la biblioteca
  final bool isLoading;

  /// Mensaje de error si ocurrió uno
  final String? error;

  /// Constructor
  LibraryState({
    this.songs = const [],
    this.playlists = const [],
    this.selectedSong,
    this.isLoading = false,
    this.error,
  });

  /// Estado inicial vacío
  static final LibraryState initial = LibraryState();

  /// Crea una copia con campos actualizados
  LibraryState copyWith({
    List<Song>? songs,
    List<Playlist>? playlists,
    Song? selectedSong,
    bool? isLoading,
    String? error,
  }) {
    return LibraryState(
      songs: songs ?? this.songs,
      playlists: playlists ?? this.playlists,
      selectedSong: selectedSong ?? this.selectedSong,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Cantidad total de canciones
  int get songCount => songs.length;

  /// Cantidad total de playlists
  int get playlistCount => playlists.length;

  @override
  String toString() {
    if (error != null) return 'LibraryState.error(message: $error)';
    if (isLoading) return 'LibraryState.loading';
    return 'LibraryState(songs: $songCount, playlists: $playlistCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LibraryState &&
        other.songs == songs &&
        other.playlists == playlists &&
        other.selectedSong == selectedSong &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode =>
      Object.hash(songs, playlists, selectedSong, isLoading, error);
}

/// Representa una canción en la biblioteca
class Song {
  /// ID único de la canción
  final String id;

  /// Título de la canción
  final String title;

  /// Artista de la canción
  final String artist;

  /// Álbum de la canción (opcional)
  final String? album;

  /// Género musical (opcional)
  final String? genre;

  /// Duración en milisegundos
  final int durationMs;

  /// Ruta o URL del archivo de audio
  final String filePath;

  /// Fecha de agregado a la biblioteca
  final DateTime addedAt;

  /// Constructor
  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.genre,
    required this.durationMs,
    required this.filePath,
    required this.addedAt,
  });

  @override
  String toString() {
    return 'Song(title: $title, artist: $artist)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Representa una playlist de canciones
class Playlist {
  /// ID único de la playlist
  final String id;

  /// Nombre de la playlist
  final String name;

  /// Descripción de la playlist (opcional)
  final String? description;

  /// IDs de canciones en la playlist
  final List<String> songIds;

  /// Fecha de creación
  final DateTime createdAt;

  /// Constructor
  Playlist({
    required this.id,
    required this.name,
    this.description,
    this.songIds = const [],
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Playlist(name: $name, songs: ${songIds.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Playlist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}