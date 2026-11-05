/// Eventos del módulo UI Shell.
library mymusic.features.ui_shell.domain.ui_shell_event;

import 'ui_shell_state.dart';

/// Evento para cambiar a una pestaña diferente
class ChangeTab {
  final int tabIndex;

  ChangeTab({required this.tabIndex});
}

/// Evento para abrir/cerrar el menú de navegación (drawer)
class ToggleDrawer {
  final bool isOpen;

  ToggleDrawer({required this.isOpen});
}

/// Evento para navegar a una ruta específica
class NavigateToRoute {
  final String route;

  NavigateToRoute({required this.route});
}

/// Evento para inicializar las pestañas de la aplicación
class InitializeTabs {
  final List<ShellTab> tabs;

  InitializeTabs({required this.tabs});
}

/// Evento para cerrar sesión y salir del módulo Auth
class Logout {}