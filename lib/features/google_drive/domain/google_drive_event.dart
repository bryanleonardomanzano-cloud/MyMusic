/// Eventos del módulo de Google Drive.
library mymusic.features.google_drive.domain.google_drive_event;

import 'google_drive_state.dart';

/// Evento para listar archivos de audio en Google Drive
class ListGoogleDriveFiles {
  /// Número máximo de resultados (opcional, default 50)
  final int? pageSize;

  ListGoogleDriveFiles({this.pageSize});
}

/// Evento para seleccionar un archivo de Google Drive para reproducir
class SelectDriveFile {
  final GoogleDriveFile file;

  SelectDriveFile({required this.file});
}

/// Evento para descargar un archivo de Google Drive localmente
class DownloadDriveFile {
  final GoogleDriveFile file;

  DownloadDriveFile({required this.file});
}

/// Evento para limpiar la lista de archivos
class ClearGoogleDriveFiles {}