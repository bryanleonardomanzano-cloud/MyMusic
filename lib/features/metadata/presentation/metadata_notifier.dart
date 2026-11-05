/// StateNotifier que maneja la lógica de lectura de metadatos de audio.
/// Emite instancias de [MetadataState].
library mymusic.features.metadata.presentation.metadata_notifier;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymusic/features/metadata/data/metadata_data_source.dart';
import 'package:mymusic/features/metadata/domain/metadata_state.dart';

/// StateNotifier que maneja el estado de metadatos de audio.
class MetadataNotifier extends StateNotifier<MetadataState> {
  final MetadataDataSource _dataSource;

  MetadataNotifier({required MetadataDataSource dataSource})
      : _dataSource = dataSource,
        super(MetadataState.initial);

  /// Leer metadatos de un archivo de audio
  Future<void> readMetadata({required String filePath}) async {
    state = MetadataState(
      filePath: filePath,
      isLoading: true,
      error: null,
    );

    try {
      final metadata = await _dataSource.readMetadata(filePath: filePath);
      state = metadata;
    } catch (e) {
      state = MetadataState(
        filePath: filePath,
        isLoading: false,
        error: 'Error al leer metadatos: $e',
      );
    }
  }

  /// Leer metadatos de múltiples archivos de audio
  Future<List<MetadataState>> readMultipleMetadata({
    required List<String> filePaths,
  }) async {
    if (filePaths.isEmpty) {
      return [];
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _dataSource.readMultipleMetadata(
        filePaths: filePaths,
      );
      state = state.copyWith(isLoading: false);
      return results;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al leer metadatos: $e',
      );
      return [];
    }
  }

  /// Limpiar metadatos actuales y volver al estado inicial
  Future<void> clear() async {
    state = MetadataState.initial;
  }

  /// Dispose recursos del data source
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
    super.dispose();
  }
}