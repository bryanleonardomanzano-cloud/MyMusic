/// Data source interface para el módulo UI Shell.
/// Define el contrato para gestionar la navegación y pestañas.
library mymusic.features.ui_shell.data.ui_shell_data_source;

import 'package:mymusic/features/ui_shell/domain/ui_shell_state.dart';

abstract class UiShellDataSource {
  /// Obtener las pestañas disponibles para la navegación
  Future<List<ShellTab>> getTabs();

  /// Guardar la pestaña seleccionada por el usuario
  Future<void> saveSelectedTab(int tabIndex);

  /// Obtener la última pestaña seleccionada por el usuario
  Future<int?> getLastSelectedTab();

  /// Dispose recursos
  Future<void> dispose();
}