/// Eventos que pueden trigger el estado del reproductor.
/// Estos eventos son añadidos por la presentación y manejados por el notifier.
/// Equivalente a los auth_event.dart del módulo auth.

/// Cargar reproducción de una pista
class LoadTrack {
  final String trackId;
  final String title;
  final String artist;
  final int duration; // en milisegundos
  final List<String> playlist;
  final int initialPosition;

  LoadTrack({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.duration,
    required this.playlist,
    this.initialPosition = 0,
  });
}

/// Pausa/reanudar reproducción
class TogglePause {}

/// Buscar posición en la pista
class Seek {
  final int position; // en milisegundos

  Seek({required this.position});
}

/// Saltar a próxima pista
class NextTrack {}

/// Volver a pista anterior
class PreviousTrack {}

/// Detener reproducción
class Stop {}

/// Actualizar metadatos de la pista actual
class UpdateMetadata {
  final String title;
  final String artist;
  final int duration;

  UpdateMetadata({
    required this.title,
    required this.artist,
    required this.duration,
  });
}