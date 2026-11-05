/// Data source interface para el reproductor.
/// Define el contrato que retorna instancias de [PlayerState].
import 'package:mymusic/features/player/domain/player_state.dart';

abstract class PlayerDataSource {
  /// Stream del estado actual de reproducción
  Stream<PlayerState> get stateStream;

  /// Cargar una pista para reproducir
  Future<PlayerState> loadTrack({
    required String trackId,
    required String title,
    required String artist,
    required int duration,
    required List<String> playlist,
    int initialPosition = 0,
  });

  /// Toggle pause/resume
  Future<PlayerState> togglePause();

  /// Seek a posición en milisegundos
  Future<PlayerState> seek({required int position});

  /// Detener reproducción
  Future<PlayerState> stop();

  /// Actualizar metadatos
  Future<PlayerState> updateMetadata({
    required String title,
    required String artist,
    required int duration,
  });

  /// Dispose recursos
  Future<void> dispose();
}