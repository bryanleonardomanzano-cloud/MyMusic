/// Data source concreto que implementa [AuthRepository] usando google_sign_in.
/// Guarda el refresh token en SharedPreferences.
/// Versión simplificada: solo loginWithGoogle y logout; watchSession y refreshToken son placeholders.
library mymusic.features.auth.data.google_sign_in_data_source;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mymusic/core/errors/app_error.dart';
import 'package:mymusic/features/auth/domain/auth_state.dart';
import 'package:mymusic/features/auth/domain/auth_user.dart';
import 'package:mymusic/features/auth/domain/auth_repository.dart';

class GoogleSignInDataSource implements AuthRepository {
  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<AuthState> loginWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return AuthUninitialized();

      // Acceso a tokens; la API de google_sign_in usa account.authentication.accessToken.
      final auth = await account.authentication;
      final accessToken = auth.accessToken;

      // Validación nula segura - si no hay accessToken, es error
      if (accessToken == null) {
        return AuthUninitialized();
      }

      final user = AuthUser(
        id: account.id,
        email: account.email,
        displayName: account.displayName,
      );
      final expiration = _computeExpiration(accessToken);
      return AuthAuthenticated(user, accessToken, expiration);
    } on Exception catch (e) {
      return AuthError(networkError('loginWithGoogle', e.toString()));
    }
  }

  @override
  Future<AuthState> logout() async {
    try {
      await _googleSignIn.disconnect();
      // Limpiamos los tokens guardados
      final prefs = await _prefs;
      await prefs.remove('refresh_token');
      await prefs.clear();
      return AuthUninitialized();
    } on Exception catch (e) {
      return AuthError(offlineError('logout', e.toString()));
    }
  }

  // watchSession y refreshToken son placeholders; la implementación completa requerirá manejo detallado de sesiones.
  @override
  Future<AuthState> refreshToken() async {
    return AuthUninitialized();
  }

  @override
  Stream<AuthState> watchSession() async* {
    yield AuthUninitialized();
  }

  DateTime _computeExpiration(String accessToken) {
    final now = DateTime.now();
    return now.add(Duration(seconds: 3600));
  }
}