library mymusic.features.search.domain.search_event;

/// Eventos que pueden trigger una búsqueda en el módulo search.
/// Equivalente a los player_event.dart del módulo player.

/// Evento para buscar canciones por término de texto
class SearchTracks {
  /// Término de búsqueda
  final String query;

  /// Número máximo de resultados (opcional, default 20)
  final int? limit;

  SearchTracks({
    required this.query,
    this.limit,
  }) : assert(query.isNotEmpty, 'El término de búsqueda no puede estar vacío');
}

/// Evento para limpiar los resultados de búsqueda
class ClearSearch {}

/// Evento para seleccionar un resultado de búsqueda
class SelectSearchResult {
  /// ID del resultado seleccionado
  final String resultId;

  SelectSearchResult({required this.resultId});
}