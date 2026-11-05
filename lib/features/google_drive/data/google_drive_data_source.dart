/// Data source interface para el módulo de Google Drive.
/// Define el contrato para listar y descargar archivos desde Google Drive.
library mymusic.features.google_drive.data.google_drive_data_source;

import 'package:mymusic/features/google_drive/domain/google_drive_state.dart';

abstract class GoogleDriveDataSource {
  /// Listar archivos de audio disponibles en Google Drive
  Future<List<GoogleDriveFile>> listAudioFiles({
    int? pageSize,
    String? pageToken,
  });

  /// Obtener URL de descarga directa de un archivo
  Future<String?> getDownloadUrl(String fileId);

  /// Obtener metadatos de un archivo específico
  Future<GoogleDriveFile?> getFile(String fileId);

  /// Dispose recursos
  Future<void> dispose();
}