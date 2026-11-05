/// StateNotifier que maneja la lógica de Google Drive.
/// Emite instancias de [GoogleDriveState].
library mymusic.features.google_drive.presentation.google_drive_notifier;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymusic/features/google_drive/data/google_drive_data_source.dart';
import 'package:mymusic/features/google_drive/domain/google_drive_state.dart';

/// StateNotifier que maneja el estado de Google Drive.
class GoogleDriveNotifier extends StateNotifier<GoogleDriveState> {
  final GoogleDriveDataSource _dataSource;

  GoogleDriveNotifier({required GoogleDriveDataSource dataSource})
      : _dataSource = dataSource,
        super(GoogleDriveState.initial);

  /// Listar archivos de audio en Google Drive
  Future<void> listAudioFiles({
    int? pageSize,
    String? pageToken,
  }) async {
    state = GoogleDriveState(
      files: state.files,
      isLoading: true,
      error: null,
    );

    try {
      final files = await _dataSource.listAudioFiles(
        pageSize: pageSize,
        pageToken: pageToken,
      );

      state = state.copyWith(
        files: pageToken == null ? files : [...state.files, ...files],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al listar archivos de Google Drive: $e',
      );
    }
  }

  /// Seleccionar un archivo para reproducir
  Future<void> selectFile(GoogleDriveFile file) async {
    state = state.copyWith(selectedFile: file);
  }

  /// Obtener URL de descarga de un archivo
  Future<String?> getDownloadUrl(String fileId) async {
    try {
      return await _dataSource.getDownloadUrl(fileId);
    } catch (e) {
      state = state.copyWith(error: 'Error al obtener URL de descarga: $e');
      return null;
    }
  }

  /// Obtener metadatos de un archivo específico
  Future<GoogleDriveFile?> getFile(String fileId) async {
    try {
      return await _dataSource.getFile(fileId);
    } catch (e) {
      state = state.copyWith(error: 'Error al obtener archivo: $e');
      return null;
    }
  }

  /// Limpiar lista de archivos
  Future<void> clear() async {
    state = GoogleDriveState.initial;
  }

  /// Dispose recursos del data source
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
    super.dispose();
  }
}