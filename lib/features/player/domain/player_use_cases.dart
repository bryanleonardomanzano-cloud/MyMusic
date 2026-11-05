/// Casos de uso para el módulo player.
/// Funciones puras que transforman eventos en instancias de PlayerState.
import 'player_event.dart';
import 'player_state.dart';

// Helper para verificar si hay reproducción
bool _hasTrack(PlayerState state) =>
    state.currentTrack != null && state.duration != null && state.duration! > 0;

/// Carga una pista para reproducir
PlayerState loadTrack(LoadTrack event) =>
    PlayerState(
      currentTrack: event.title,
      duration: event.duration,
      position: event.initialPosition,
      artist: event.artist,
      playlist: event.playlist,
    );

/// Toggle pause/resumen basado en estado actual
PlayerState togglePause(TogglePause event, PlayerState currentState) {
  if (_hasTrack(currentState)) {
    return PlayerState(
      currentTrack: currentState.currentTrack,
      duration: currentState.duration,
      position: currentState.position,
      artist: currentState.artist,
      playlist: currentState.playlist,
    );
  }
  // Default: iniciar reproducción
  return PlayerState(
    currentTrack: 'Track',
    duration: 180000,
    position: 0,
    artist: 'Artist',
    playlist: [],
  );
}

/// Seek a posición
PlayerState seek(Seek event, PlayerState currentState) =>
    PlayerState(
      currentTrack: currentState.currentTrack,
      duration: currentState.duration,
      position: event.position,
      artist: currentState.artist,
      playlist: currentState.playlist,
    );

/// Detener reproducción
PlayerState stop(Stop event, PlayerState currentState) =>
    PlayerState.initial;

/// Update metadata
PlayerState updateMetadata(UpdateMetadata event, PlayerState currentState) =>
    PlayerState(
      currentTrack: event.title,
      duration: event.duration,
      position: currentState.position,
      artist: event.artist,
      playlist: currentState.playlist,
    );