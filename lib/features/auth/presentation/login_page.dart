library mymusic.features.auth.presentation.login_page;

/// Pantalla de login con cuenta Google.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mymusic/features/auth/domain/auth_state.dart';
import 'package:mymusic/features/auth/presentation/providers.dart';

/// Pantalla de login con cuenta Google.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Estado visual
            if (auth is AuthAuthenticated) ...[
              Text('Bienvenido, ${auth.user.email}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                child: const Text('Cerrar sesión'),
              ),
            ] else ...[
              const Text('Por favor, inicia sesión con Google'),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => ref.read(authProvider.notifier).login(),
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Continuar con Google'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}