/// Estado del módulo de Metadatos de audio.
/// Contiene la información de metadatos ID3 de una canción.
library mymusic.features.metadata.domain.metadata_state;

/// Estado de los metadatos de una canción.
class MetadataState {
  /// Título de la canción
  final String? title;

  /// Artista de la canción
  final String? artist;

  /// Álbum de la canción
  final String? album;

  /// Género musical
  final String? genre;

  /// Año de lanzamiento
  final int? year;

  /// Número de pista
  final int? trackNumber;

  /// Duración en milisegundos
  final int? durationMs;

  /// Tamaño del archivo en bytes
  final int? fileSize;

  /// Ruta del archivo de audio
  final String? filePath;

  /// Indica si se están leyendo los metadatos
  final bool isLoading;

  /// Mensaje de error si ocurrió uno
  final String? error;

  /// Constructor
  MetadataState({
    this.title,
    this.artist,
    this.album,
    this.genre,
    this.year,
    this.trackNumber,
    this.durationMs,
    this.fileSize,
    this.filePath,
    this.isLoading = false,
    this.error,
  });

  /// Estado inicial vacío
  static final MetadataState initial = MetadataState();

  /// Crea una copia con campos actualizados
  MetadataState copyWith({
    String? title,
    String? artist,
    String? album,
    String? genre,
    int? year,
    int? trackNumber,
    int? durationMs,
    int? fileSize,
    String? filePath,
    bool? isLoading,
    String? error,
  }) {
    return MetadataState(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      trackNumber: trackNumber ?? this.trackNumber,
      durationMs: durationMs ?? this.durationMs,
      fileSize: fileSize ?? this.fileSize,
      filePath: filePath ?? this.filePath,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Indica si hay metadatos disponibles
  bool get hasMetadata => title != null || artist != null || album != null;

  @override
  String toString() {
    if (error != null) return 'MetadataState.error(message: $error)';
    if (isLoading) return 'MetadataState.loading';
    return 'MetadataState(title: $title, artist: $artist, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MetadataState &&
        other.title == title &&
        other.artist == artist &&
        other.album == album &&
        other.genre == genre &&
        other.year == year &&
        other.trackNumber == trackNumber &&
        other.durationMs == durationMs &&
        other.fileSize == fileSize &&
        other.filePath == filePath &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode =>
      Object.hash(title, artist, album, genre, year, trackNumber, durationMs,
          fileSize, filePath, isLoading, error);
}