/// Estado del reproductor de música.
/// Clase simple con campos opcionales.
/// Equivalente en simplicidad a auth_state.dart del módulo auth.
class PlayerState {
  /// Track actual
  final String? currentTrack;

  /// Duración en ms
  final int? duration;

  /// Posición en ms
  final int? position;

  /// Artista
  final String? artist;

  /// Playlist
  final List<String>? playlist;

  /// Message for error states
  final String? message;

  /// Constructor
  PlayerState({
    this.currentTrack,
    this.duration,
    this.position,
    this.artist,
    this.playlist,
    this.message,
  });

  /// Estado inicial / sin reproducción
  static final PlayerState initial = PlayerState();

  /// Estado de reproducción activa
  factory PlayerState.playing({
    required String currentTrack,
    required int duration,
    required int position,
    String? artist,
    List<String>? playlist,
  }) =>
      PlayerState(
        currentTrack: currentTrack,
        duration: duration,
        position: position,
        artist: artist,
        playlist: playlist,
      );

  /// Estado de pausa
  factory PlayerState.paused({
    required String currentTrack,
    required int duration,
    required int position,
    String? artist,
    List<String>? playlist,
  }) =>
      PlayerState(
        currentTrack: currentTrack,
        duration: duration,
        position: position,
        artist: artist,
        playlist: playlist,
      );

  /// Estado de error
  factory PlayerState.error({required String message}) =>
      PlayerState(
        currentTrack: null,
        duration: null,
        position: null,
        message: message,
      );

  @override
  String toString() {
    if (message != null) return 'PlayerState.error(message: $message)';
    if (currentTrack != null && duration != null && duration! > 0)
      return 'PlayerState.playing';
    if (currentTrack != null) return 'PlayerState.paused';
    return 'PlayerState.initial()';
  }
}