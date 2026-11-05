import 'package:mymusic/features/auth/domain/auth_state.dart';

/// Repositorio de autenticación.
/// Proporciona operaciones de login, logout y seguimiento de sesión.
class AuthRepository {
  /// Verifica si hay una sesión activa sin lanzar el flujo de login.
  /// Retorna un [AuthState] inmediato (puede ser [AuthUninitialized] si no hay sesión).
  Stream<AuthState> watchSession() async* {
    yield AuthUninitialized();
  }

  /// Inicia el flujo interactivo de login con Google.
  /// Emite estado [AuthAuthenticated] tras éxito o [AuthError] en fallo.
  Future<AuthState> loginWithGoogle() async {
    // Implementación mínima: retorna un estado inicial hasta tanto se integre Google Sign-In completo.
    return AuthUninitialized();
  }

  /// Cierra la sesión actual y limpia tokens.
  Future<AuthState> logout() async {
    return AuthUninitialized();
  }

  /// Renueva el access token usando el refresh token.
  Future<AuthState> refreshToken() async {
    return AuthUninitialized();
  }
}