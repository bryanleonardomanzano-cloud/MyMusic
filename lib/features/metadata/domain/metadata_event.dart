/// Eventos del módulo de Metadatos de audio.
library mymusic.features.metadata.domain.metadata_event;

/// Evento para leer metadatos de un archivo de audio
class ReadMetadata {
  final String filePath;

  ReadMetadata({required this.filePath});
}

/// Evento para limpiar los metadatos actuales
class ClearMetadata {}