library mymusic.features.auth.domain.auth_state;

/// Estados posibles del módulo de autenticación.
/// AuthState es la clase base para todos los estados de auth.
import 'package:mymusic/core/errors/app_error.dart';
import 'package:mymusic/features/auth/domain/auth_user.dart';

class AuthState {}

/// Estado inicial / desconocido (al cargar la app).
class AuthInitial extends AuthState {}

/// Sesión activa con token de Google.
class AuthAuthenticated extends AuthState {
  final AuthUser user;
  final String accessToken; // expira, necesita refresh
  final DateTime tokenExpiration;

  AuthAuthenticated(this.user, this.accessToken, this.tokenExpiration);
}

/// El usuario aún no ha iniciado sesión.
class AuthUninitialized extends AuthState {}

/// Error durante el login o refresh.
class AuthError extends AuthState {
  final AppError error;
  AuthError(this.error);
}