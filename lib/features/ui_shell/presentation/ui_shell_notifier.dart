/// StateNotifier que maneja la lógica de navegación del UI Shell.
/// Emite instancias de [UiShellState].
library mymusic.features.ui_shell.presentation.ui_shell_notifier;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymusic/features/ui_shell/data/ui_shell_data_source.dart';
import 'package:mymusic/features/ui_shell/domain/ui_shell_state.dart';

/// StateNotifier que maneja el estado de navegación del UI Shell.
class UiShellNotifier extends StateNotifier<UiShellState> {
  final UiShellDataSource _dataSource;

  UiShellNotifier({required UiShellDataSource dataSource})
      : _dataSource = dataSource,
        super(UiShellState.initial);

  /// Cargar las pestañas de navegación
  Future<void> loadTabs() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tabs = await _dataSource.getTabs();
      state = state.copyWith(
        tabs: tabs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar pestañas: $e',
      );
    }
  }

  /// Cambiar a una pestaña diferente
  Future<void> changeTab(int tabIndex) async {
    if (tabIndex < 0 || tabIndex >= state.tabs.length) {
      state = state.copyWith(error: 'Pestaña no válida');
      return;
    }

    state = state.copyWith(
      currentTabIndex: tabIndex,
      isDrawerOpen: false,
    );

    await _dataSource.saveSelectedTab(tabIndex);
  }

  /// Abrir/cerrar el menú de navegación (drawer)
  Future<void> toggleDrawer(bool isOpen) async {
    state = state.copyWith(isDrawerOpen: isOpen);
  }

  /// Navegar a una ruta específica
  Future<void> navigateToRoute(String route) async {
    state = state.copyWith(
      error: null,
      isDrawerOpen: false,
    );
    // La navegación real se maneja mediante el router de la aplicación
  }

  /// Limpiar errores
  Future<void> clearError() async {
    state = state.copyWith(error: null);
  }

  /// Dispose recursos del data source
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
    super.dispose();
  }
}