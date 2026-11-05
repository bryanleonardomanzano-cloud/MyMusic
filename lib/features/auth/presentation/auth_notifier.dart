import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mymusic/features/auth/domain/auth_repository.dart';
import 'package:mymusic/features/auth/domain/auth_state.dart';

// StateNotifier que maneja el estado de autenticación.
// Recibe un estado inicial mediante el constructor.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier({required this._repository, AuthState? initialState})
      : super(initialState ?? AuthUninitialized());

  /// Inicia sesión con Google.
  Future<void> login() async {
    final result = await _repository.loginWithGoogle();
    state = result;
  }

  /// Cierra sesión.
  Future<void> logout() async {
    final result = await _repository.logout();
    state = result;
  }

  /// Refresca el token.
  Future<void> refresh() async {
    final result = await _repository.refreshToken();
    state = result;
  }
}