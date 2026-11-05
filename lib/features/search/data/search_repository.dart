library mymusic.features.search.data.search_repository;

/// Repositorio implementa [SearchDataSource].
/// Entrega instancias de [SearchResult] desde la búsqueda.
/// Esta versión usa datos simulados (mock); la implementación completa
/// integrará con Google Drive o una base de datos local.
import 'package:mymusic/features/search/data/search_data_source.dart';
import 'package:mymusic/features/search/domain/search_state.dart';

class SearchRepository implements SearchDataSource {
  /// Catálogo simulado de canciones disponibles
  final List<SearchResult> _mockCatalog = [
    SearchResult(
      id: 'track_001',
      title: 'Mi canción favorita',
      artist: 'Artista Uno',
      album: 'Álbum Principal',
      duration: 240000,
      audioUrl: 'assets/audio/track_001.mp3',
    ),
    SearchResult(
      id: 'track_002',
      title: 'Canción de verano',
      artist: 'Artista Dos',
      album: 'Éxitos 2024',
      duration: 180000,
      audioUrl: 'assets/audio/track_002.mp3',
    ),
    SearchResult(
      id: 'track_003',
      title: 'Balada romántica',
      artist: 'Artista Tres',
      album: 'Amor y Pasión',
      duration: 300000,
      audioUrl: 'assets/audio/track_003.mp3',
    ),
    SearchResult(
      id: 'track_004',
      title: 'Rock energético',
      artist: 'Banda Roca',
      album: 'Potencia',
      duration: 210000,
      audioUrl: 'assets/audio/track_004.mp3',
    ),
    SearchResult(
      id: 'track_005',
      title: 'Jazz nocturno',
      artist: 'Músico Jazz',
      album: 'Noches de Jazz',
      duration: 270000,
      audioUrl: 'assets/audio/track_005.mp3',
    ),
  ];

  @override
  Future<List<SearchResult>> searchTracks({
    required String query,
    int? limit,
  }) async {
    // Simular latencia de red
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.isEmpty) {
      return [];
    }

    final lowerQuery = query.toLowerCase();

    final results = _mockCatalog.where((track) {
      return track.title.toLowerCase().contains(lowerQuery) ||
          track.artist.toLowerCase().contains(lowerQuery) ||
          (track.album != null &&
              track.album!.toLowerCase().contains(lowerQuery));
    }).toList();

    // Aplicar límite si se especifica
    if (limit != null && limit > 0) {
      return results.take(limit).toList();
    }

    return results;
  }

  @override
  Future<List<String>> getSuggestions({required String query}) async {
    // Simular latencia de red
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) {
      return [];
    }

    final lowerQuery = query.toLowerCase();

    // Obtener sugerencias basadas en títulos y artistas que coincidan
    final suggestions = <String>{};

    for (final track in _mockCatalog) {
      if (track.title.toLowerCase().contains(lowerQuery)) {
        suggestions.add(track.title);
      }
      if (track.artist.toLowerCase().contains(lowerQuery)) {
        suggestions.add(track.artist);
      }
    }

    return suggestions.toList();
  }

  @override
  Future<void> dispose() async {
    // No hay recursos que liberar en esta implementación mock
  }
}