/// Repositorio implementa [PlayerDataSource] usando [just_audio].
/// Encapsula la dependencia de Flutter/just_audio para aislarla
/// de la lógica domain pura.
import 'dart:async';

import 'package:just_audio/just_audio.dart' as ja;

import 'package:mymusic/features/player/data/player_data_source.dart';
import 'package:mymusic/features/player/domain/player_state.dart';

class PlayerRepository implements PlayerDataSource {
  /// Instancia de just_audio
  final _player = ja.AudioPlayer();

  /// Stream controller para emitir estados propios
  final _stateController = StreamController<PlayerState>.broadcast();

  String? _currentTrack;

  @override
  Stream<PlayerState> get stateStream => _stateController.stream;

  @override
  Future<PlayerState> loadTrack({
    required String trackId,
    required String title,
    required String artist,
    required int duration,
    required List<String> playlist,
    int initialPosition = 0,
  }) async {
    try {
      _currentTrack = title;
      // Emitir estado de reproducción
      _stateController.add(PlayerState.playing(
        currentTrack: title,
        duration: duration,
        position: initialPosition,
        artist: artist,
        playlist: playlist,
      ));
      return PlayerState.playing(
        currentTrack: title,
        duration: duration,
        position: initialPosition,
        artist: artist,
        playlist: playlist,
      );
    } catch (e) {
      final errorState = PlayerState.error(message: 'Error al cargar pista: $e');
      _stateController.add(errorState);
      return errorState;
    }
  }

  @override
  Future<PlayerState> togglePause() async {
    try {
      if (_player.playing) {
        await _player.pause();
        final pausedState = PlayerState.paused(
          currentTrack: _currentTrack ?? 'Track',
          duration: _player.duration?.inMilliseconds ?? 180000,
          position: _player.position.inMilliseconds,
        );
        _stateController.add(pausedState);
        return pausedState;
      } else {
        await _player.play();
        final playingState = PlayerState.playing(
          currentTrack: _currentTrack ?? 'Track',
          duration: _player.duration?.inMilliseconds ?? 180000,
          position: _player.position.inMilliseconds,
        );
        _stateController.add(playingState);
        return playingState;
      }
    } catch (e) {
      final errorState = PlayerState.error(message: 'Error al alternar pausa: $e');
      _stateController.add(errorState);
      return errorState;
    }
  }

  @override
  Future<PlayerState> seek({required int position}) async {
    try {
      await _player.seek(Duration(milliseconds: position));
      final seekState = PlayerState.playing(
        currentTrack: _currentTrack ?? 'Track',
        duration: _player.duration?.inMilliseconds ?? 0,
        position: position,
      );
      _stateController.add(seekState);
      return seekState;
    } catch (e) {
      final errorState = PlayerState.error(message: 'Error al buscar: $e');
      _stateController.add(errorState);
      return errorState;
    }
  }

  @override
  Future<PlayerState> stop() async {
    try {
      await _player.stop();
      final initialState = PlayerState.initial;
      _stateController.add(initialState);
      return initialState;
    } catch (e) {
      final errorState = PlayerState.error(message: 'Error al detener: $e');
      _stateController.add(errorState);
      return errorState;
    }
  }

  @override
  Future<PlayerState> updateMetadata({
    required String title,
    required String artist,
    required int duration,
  }) async {
    _currentTrack = title;
    final updatedState = PlayerState.playing(
      currentTrack: title,
      duration: duration,
      position: 0,
      artist: artist,
      playlist: [],
    );
    _stateController.add(updatedState);
    return updatedState;
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _player.dispose();
  }
}