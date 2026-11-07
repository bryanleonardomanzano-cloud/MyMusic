/// Google Sign-In implementation for Android and iOS.
/// Access tokens are obtained from the native Google SDK when requested; this
/// app deliberately does not persist OAuth tokens or Google passwords.
library mymusic.features.auth.data.google_sign_in_data_source;

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:mymusic/core/errors/app_error.dart';
import 'package:mymusic/features/auth/domain/auth_repository.dart';
import 'package:mymusic/features/auth/domain/auth_state.dart';
import 'package:mymusic/features/auth/domain/auth_user.dart';

const driveReadOnlyScope = 'https://www.googleapis.com/auth/drive.readonly';

class GoogleSignInDataSource implements AuthRepository {
  GoogleSignInDataSource({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ??
            GoogleSignIn(scopes: const <String>[driveReadOnlyScope]);

  final GoogleSignIn _googleSignIn;
  static const _requiredScopes = <String>[driveReadOnlyScope];

  bool get _isSupportedPlatform =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Future<AuthState> loginWithGoogle() async {
    if (!_isSupportedPlatform) {
      return AuthError(authError(
        'unsupported_platform',
        'Google Sign-In de este proyecto está habilitado para Android e iOS. '
            'Windows requiere un flujo OAuth de escritorio separado.',
      ));
    }

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return AuthUninitialized();

      // Solicita el permiso de Drive solo después de que el usuario elige su
      // cuenta. No pedimos permisos de escritura ni guardamos credenciales.
      if (!await account.canAccessScopes(_requiredScopes)) {
        final granted = await account.requestScopes(_requiredScopes);
        if (!granted) {
          return AuthError(authError(
            'drive_scope_denied',
            'Se necesita permiso de lectura de Google Drive para mostrar tu música.',
          ));
        }
      }
      return _authenticatedState(account);
    } catch (error) {
      return AuthError(authError('sign_in', error.toString()));
    }
  }

  @override
  Future<AuthState> refreshToken() async {
    if (!_isSupportedPlatform) {
      return AuthError(authError('unsupported_platform',
          'La renovación de sesión está disponible en Android e iOS.'));
    }
    try {
      final account = _googleSignIn.currentUser ??
          await _googleSignIn.signInSilently(suppressErrors: true);
      if (account == null) return AuthUninitialized();
      if (!await account.canAccessScopes(_requiredScopes)) {
        return AuthError(authError(
          'drive_scope_required',
          'Vuelve a iniciar sesión y autoriza el permiso de solo lectura de Drive.',
        ));
      }
      // google_sign_in administra la renovación nativa. Leer authentication
      // vuelve a obtener el access token actual; no existe refresh_token público
      // en este flujo del plugin.
      return _authenticatedState(account);
    } catch (error) {
      return AuthError(authError('token_refresh', error.toString()));
    }
  }

  /// Devuelve un access token vigente para las llamadas a Drive.
  /// El token se mantiene en memoria del SDK de Google, nunca en preferencias.
  Future<String> getAccessToken({bool forceRefresh = false}) async {
    if (!_isSupportedPlatform) {
      throw UnsupportedError(
          'Configura un flujo OAuth de escritorio para Google Drive en Windows.');
    }
    final account = _googleSignIn.currentUser ??
        await _googleSignIn.signInSilently(suppressErrors: true);
    if (account == null) {
      throw StateError('Inicia sesión con Google para acceder a Drive.');
    }
    if (!await account.canAccessScopes(_requiredScopes)) {
      throw StateError('La cuenta no autorizó el permiso drive.readonly.');
    }

    // La API v6 del plugin no expone refreshToken/forceRefresh. El SDK nativo
    // renueva o vuelve a adquirir el token al consultar authentication.
    final authentication = await account.authentication;
    final token = authentication.accessToken;
    if (token == null || token.isEmpty) {
      // Un nuevo flujo interactivo es el fallback si el SDK no pudo renovar.
      if (forceRefresh) {
        final signedInAccount = await _googleSignIn.signIn();
        if (signedInAccount != null &&
            await signedInAccount.canAccessScopes(_requiredScopes)) {
          final refreshed = (await signedInAccount.authentication).accessToken;
          if (refreshed != null && refreshed.isNotEmpty) return refreshed;
        }
      }
      throw StateError('Google no devolvió un access token válido.');
    }
    return token;
  }

  @override
  Stream<AuthState> watchSession() async* {
    if (!_isSupportedPlatform) {
      yield AuthUninitialized();
      return;
    }
    try {
      final current = _googleSignIn.currentUser ??
          await _googleSignIn.signInSilently(suppressErrors: true);
      yield current == null ? AuthUninitialized() : await _stateForExistingAccount(current);
      await for (final account in _googleSignIn.onCurrentUserChanged) {
        yield account == null
            ? AuthUninitialized()
            : await _stateForExistingAccount(account);
      }
    } catch (error) {
      yield AuthError(authError('watch_session', error.toString()));
    }
  }

  Future<AuthState> _stateForExistingAccount(GoogleSignInAccount account) async {
    if (!await account.canAccessScopes(_requiredScopes)) {
      return AuthError(authError(
        'drive_scope_required',
        'Autoriza el permiso de solo lectura de Drive para usar tu biblioteca.',
      ));
    }
    return _authenticatedState(account);
  }

  Future<AuthState> _authenticatedState(GoogleSignInAccount account) async {
    final authentication = await account.authentication;
    final accessToken = authentication.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return AuthError(authError('missing_access_token',
          'Google no proporcionó un token para Google Drive.'));
    }
    return AuthAuthenticated(
      AuthUser(
        id: account.id,
        email: account.email,
        displayName: account.displayName,
      ),
      accessToken,
      // google_sign_in no expone expires_in; esta fecha es orientativa. Para
      // cada petición se vuelve a consultar al SDK, no se confía en ella.
      DateTime.now().add(const Duration(minutes: 50)),
    );
  }

  @override
  Future<AuthState> logout() async {
    try {
      await _googleSignIn.signOut();
      return AuthUninitialized();
    } catch (error) {
      return AuthError(authError('sign_out', error.toString()));
    }
  }
}
