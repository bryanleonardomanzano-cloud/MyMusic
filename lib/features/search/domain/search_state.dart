/// Estado del módulo de búsqueda de canciones.
/// Clase simple con campos opcionales.
class SearchState {
  /// Término de búsqueda actual
  final String? query;

  /// Resultados de búsqueda
  final List<SearchResult>? results;

  /// Indica si hay una búsqueda en curso
  final bool isLoading;

  /// Mensaje de error si ocurrió uno
  final String? error;

  /// Constructor
  SearchState({
    this.query,
    this.results,
    this.isLoading = false,
    this.error,
  });

  /// Estado inicial vacío
  static final SearchState initial = SearchState();

  @override
  String toString() {
    if (error != null) return 'SearchState.error(message: $error)';
    if (isLoading) return 'SearchState.loading';
    if (results != null && results!.isNotEmpty)
      return 'SearchState.results(count: ${results!.length})';
    return 'SearchState.initial()';
  }
}

/// Resultado individual de búsqueda de una canción
class SearchResult {
  /// ID único de la canción
  final String id;

  /// Título de la canción
  final String title;

  /// Artista de la canción
  final String artist;

  /// Álbum de la canción (opcional)
  final String? album;

  /// Duración en milisegundos
  final int? duration;

  /// URL o ruta del archivo de audio
  final String? audioUrl;

  /// Constructor
  SearchResult({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.duration,
    this.audioUrl,
  });

  @override
  String toString() {
    return 'SearchResult(title: $title, artist: $artist)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}