/// Estado del módulo de Playlists.
/// Contiene las listas de reproducción y las canciones seleccionadas.
library mymusic.features.playlists.domain.playlist_state;

/// Estado del módulo de Playlists.
class PlaylistState {
  /// Lista de playlists
  final List<Playlist> playlists;

  /// Playlist actualmente seleccionada
  final Playlist? selectedPlaylist;

  /// Indica si se está cargando la biblioteca de playlists
  final bool isLoading;

  /// Mensaje de error si ocurrió uno
  final String? error;

  /// Constructor
  PlaylistState({
    this.playlists = const [],
    this.selectedPlaylist,
    this.isLoading = false,
    this.error,
  });

  /// Estado inicial vacío
  static final PlaylistState initial = PlaylistState();

  /// Crea una copia con campos actualizados
  PlaylistState copyWith({
    List<Playlist>? playlists,
    Playlist? selectedPlaylist,
    bool? isLoading,
    String? error,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      selectedPlaylist: selectedPlaylist ?? this.selectedPlaylist,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Cantidad total de playlists
  int get playlistCount => playlists.length;

  @override
  String toString() {
    if (error != null) return 'PlaylistState.error(message: $error)';
    if (isLoading) return 'PlaylistState.loading';
    return 'PlaylistState(playlists: $playlistCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlaylistState &&
        other.playlists == playlists &&
        other.selectedPlaylist == selectedPlaylist &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(playlists, selectedPlaylist, isLoading, error);
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

  /// Crea una copia con campos actualizados
  Playlist copyWith({
    String? name,
    String? description,
    List<String>? songIds,
  }) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      songIds: songIds ?? this.songIds,
      createdAt: createdAt,
    );
  }

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