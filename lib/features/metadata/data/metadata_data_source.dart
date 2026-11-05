/// Data source interface para el módulo de Metadatos.
/// Define el contrato para leer metadatos ID3 de archivos de audio.
library mymusic.features.metadata.data.metadata_data_source;

import 'package:mymusic/features/metadata/domain/metadata_state.dart';

abstract class MetadataDataSource {
  /// Leer metadatos ID3 de un archivo de audio
  /// Retorna un objeto [MetadataState] con la información encontrada
  Future<MetadataState> readMetadata({
    required String filePath,
  });

  /// Leer metadatos de múltiples archivos de audio
  Future<List<MetadataState>> readMultipleMetadata({
    required List<String> filePaths,
  });

  /// Dispose recursos
  Future<void> dispose();
}