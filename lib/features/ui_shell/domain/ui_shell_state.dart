/// Estado del módulo UI Shell - Pantalla principal con navegación.
/// Contiene el estado de navegación entre los módulos de la aplicación.
library mymusic.features.ui_shell.domain.ui_shell_state;

/// Estado del módulo UI Shell.
class UiShellState {
  /// Índice de la pestaña actualmente seleccionada (0-based)
  final int currentTabIndex;

  /// Lista de pestañas disponibles
  final List<ShellTab> tabs;

  /// Indica si se está mostrando el menú de navegación (drawer)
  final bool isDrawerOpen;

  /// Indica si se está cargando la aplicación
  final bool isLoading;

  /// Mensaje de error si ocurrió uno
  final String? error;

  /// Constructor
  UiShellState({
    this.currentTabIndex = 0,
    this.tabs = const [],
    this.isDrawerOpen = false,
    this.isLoading = false,
    this.error,
  });

  /// Estado inicial vacío
  static final UiShellState initial = UiShellState();

  /// Crea una copia con campos actualizados
  UiShellState copyWith({
    int? currentTabIndex,
    List<ShellTab>? tabs,
    bool? isDrawerOpen,
    bool? isLoading,
    String? error,
  }) {
    return UiShellState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      tabs: tabs ?? this.tabs,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    if (error != null) return 'UiShellState.error(message: $error)';
    if (isLoading) return 'UiShellState.loading';
    return 'UiShellState(tabIndex: $currentTabIndex, tabs: ${tabs.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UiShellState &&
        other.currentTabIndex == currentTabIndex &&
        other.tabs == tabs &&
        other.isDrawerOpen == isDrawerOpen &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(currentTabIndex, tabs, isDrawerOpen, isLoading, error);
}

/// Representa una pestaña de navegación en la aplicación
class ShellTab {
  /// ID único de la pestaña
  final String id;

  /// Nombre de la pestaña (mostrado en la UI)
  final String title;

  /// Ícono de la pestaña (nombre del icono de Material Icons)
  final String icon;

  /// Ruta de navegación asociada
  final String route;

  /// Ícono activo (cuando está seleccionada)
  final String? activeIcon;

  /// Constructor
  ShellTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.activeIcon,
  });

  @override
  String toString() {
    return 'ShellTab(title: $title, route: $route)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShellTab && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}