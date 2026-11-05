/// Proveedores del módulo de autenticación.
library mymusic.features.auth.presentation.providers;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_repository.dart';
import '../domain/auth_state.dart';
import '../data/google_sign_in_data_source.dart';
import 'auth_notifier.dart';

/// Proveedor del repositorio de autenticación.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return GoogleSignInDataSource();
});

/// Proveedor del notificador de autenticación.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository: repository);
});