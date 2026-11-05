/// Data source interface para el módulo de búsqueda.
/// Define el contrato para obtener resultados de búsqueda.
import 'package:mymusic/features/search/domain/search_state.dart';

abstract class SearchDataSource {
  /// Buscar canciones por término de texto
  /// Retorna una lista de [SearchResult] coincidentes
  Future<List<SearchResult>> searchTracks({
    required String query,
    int? limit,
  });

  /// Obtener sugerencias de búsqueda basadas en un término parcial
  Future<List<String>> getSuggestions({required String query});

  /// Dispose recursos
  Future<void> dispose();
}