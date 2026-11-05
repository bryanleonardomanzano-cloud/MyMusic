/// StateNotifier que maneja la lógica del reproductor.
/// Emite instancias de [PlayerState].
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymusic/features/player/data/player_data_source.dart';
import 'package:mymusic/features/player/domain/player_state.dart';

class PlayerNotifier extends StateNotifier<PlayerState> {
  final PlayerDataSource _dataSource;

  PlayerNotifier({required PlayerDataSource dataSource})
      : _dataSource = dataSource,
        super(PlayerState.initial);

  /// Cargar y comenzar reproducción de una pista.
  Future<void> loadTrack({
    required String trackId,
    required String title,
    required String artist,
    required int duration,
    required List<String> playlist,
    int initialPosition = 0,
  }) async {
    state = PlayerState.initial;
    final newState = await _dataSource.loadTrack(
      trackId: trackId,
      title: title,
      artist: artist,
      duration: duration,
      playlist: playlist,
      initialPosition: initialPosition,
    );
    state = newState;
  }

  /// Alternar entre pause y resume.
  Future<void> togglePause() async {
    final newState = await _dataSource.togglePause();
    state = newState;
  }

  /// Buscar a una posición específica en la pista (ms).
  Future<void> seek({required int position}) async {
    final newState = await _dataSource.seek(position: position);
    state = newState;
  }

  /// Detener reproducción y volver al estado inicial.
  Future<void> stop() async {
    final newState = await _dataSource.stop();
    state = newState;
  }

  /// Actualizar metadatos de la pista actual.
  Future<void> updateMetadata({
    required String title,
    required String artist,
    required int duration,
  }) async {
    final newState = await _dataSource.updateMetadata(
      title: title,
      artist: artist,
      duration: duration,
    );
    state = newState;
  }

  /// Dispose recursos del data source.
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
    super.dispose();
  }
}