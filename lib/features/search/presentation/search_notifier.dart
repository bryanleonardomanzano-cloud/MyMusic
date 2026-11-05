library mymusic.features.search.presentation.search_notifier;

/// StateNotifier que maneja la lógica de búsqueda de canciones.
/// Emite instancias de [SearchState].
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymusic/features/search/data/search_data_source.dart';
import 'package:mymusic/features/search/domain/search_state.dart';

/// StateNotifier que maneja el estado de búsqueda.
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchDataSource _dataSource;

  SearchNotifier({required this._dataSource})
      : super(SearchState.initial);

  /// Buscar canciones por término de texto
  Future<void> search({
    required String query,
    int? limit,
  }) async {
    if (query.isEmpty) {
      state = SearchState.initial;
      return;
    }

    // Indicar que está cargando
    state = SearchState(
      query: query,
      isLoading: true,
    );

    try {
      final results = await _dataSource.searchTracks(
        query: query,
        limit: limit,
      );

      state = SearchState(
        query: query,
        results: results,
        isLoading: false,
      );
    } catch (e) {
      state = SearchState(
        query: query,
        isLoading: false,
        error: 'Error al buscar: $e',
      );
    }
  }

  /// Obtener sugerencias de búsqueda
  Future<List<String>> getSuggestions({required String query}) async {
    if (query.isEmpty) {
      return [];
    }

    return await _dataSource.getSuggestions(query: query);
  }

  /// Limpiar resultados de búsqueda y volver al estado inicial
  Future<void> clear() async {
    state = SearchState.initial;
  }

  /// Dispose recursos del data source
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
    super.dispose();
  }
}