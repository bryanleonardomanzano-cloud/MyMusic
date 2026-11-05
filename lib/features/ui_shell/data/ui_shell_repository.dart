/// Repositorio implementa [UiShellDataSource].
/// Gestiona las pestañas y navegación de la aplicación.
library mymusic.features.ui_shell.data.ui_shell_repository;

import 'package:mymusic/features/ui_shell/data/ui_shell_data_source.dart';
import 'package:mymusic/features/ui_shell/domain/ui_shell_state.dart';

/// Implementación de [UiShellDataSource] con datos simulados.
/// En una implementación completa, se conectaría con SharedPreferences
/// para persistir la selección de pestañas del usuario.
class UiShellRepository implements UiShellDataSource {
  /// Pestañas predeterminadas de la aplicación
  final List<ShellTab> _defaultTabs = [
    ShellTab(
      id: 'home',
      title: 'Inicio',
      icon: 'home',
      route: '/home',
    ),
    ShellTab(
      id: 'library',
      title: 'Biblioteca',
      icon: 'library_music',
      route: '/library',
    ),
    ShellTab(
      id: 'playlists',
      title: 'Listas',
      icon: 'playlist_music',
      route: '/playlists',
    ),
    ShellTab(
      id: 'search',
      title: 'Buscar',
      icon: 'search',
      route: '/search',
    ),
    ShellTab(
      id: 'player',
      title: 'Reproductor',
      icon: 'play_circle',
      route: '/player',
    ),
    ShellTab(
      id: 'auth',
      title: 'Auth',
      icon: 'person',
      route: '/auth',
    ),
  ];

  @override
  Future<List<ShellTab>> getTabs() async {
    // Simular latencia de carga
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_defaultTabs);
  }

  @override
  Future<void> saveSelectedTab(int tabIndex) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // En una implementación real, se guardaría en SharedPreferences
  }

  @override
  Future<int?> getLastSelectedTab() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // En una implementación real, se leería de SharedPreferences
    return 0;
  }

  @override
  Future<void> dispose() async {
    // No hay recursos que liberar en esta implementación mock
  }
}