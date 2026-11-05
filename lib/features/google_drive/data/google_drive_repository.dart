/// Repositorio implementa [GoogleDriveDataSource].
/// Entrega instancias de [GoogleDriveFile] desde Google Drive.
/// Esta versión usa la API de Google Drive con autenticación OAuth 2.0
/// mediante un access token proporcionado externamente.
library mymusic.features.google_drive.data.google_drive_repository;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mymusic/features/google_drive/data/google_drive_data_source.dart';
import 'package:mymusic/features/google_drive/domain/google_drive_state.dart';

/// Implementación de [GoogleDriveDataSource] que usa la API de Google Drive
/// con autenticación OAuth 2.0 mediante access token.
class GoogleDriveRepository implements GoogleDriveDataSource {
  /// Cliente HTTP autenticado
  final http.Client _httpClient;

  /// Access token de OAuth 2.0 para autenticación con Google Drive API
  final String _accessToken;

  /// ID de la carpeta raíz en Google Drive (opcional, para filtrar por carpeta)
  final String? folderId;

  /// URL base de la API de Google Drive v3
  static const String _apiBaseUrl = 'https://www.googleapis.com/drive/v3';

  GoogleDriveRepository({
    required http.Client httpClient,
    required String accessToken,
    this.folderId,
  }) : _httpClient = httpClient,
       _accessToken = accessToken;

  @override
  Future<List<GoogleDriveFile>> listAudioFiles({
    int? pageSize,
    String? pageToken,
  }) async {
    try {
      final query = _buildQuery();

      final response = await _httpClient.get(
        Uri.parse('$_apiBaseUrl/files').replace(queryParameters: {
          'pageSize': (pageSize ?? 50).toString(),
          if (pageToken != null) 'pageToken': pageToken,
          'q': query,
          'orderBy': 'modifiedTime desc',
          'fields': 'nextPageToken,files(id,name,mimeType,size,createdTime,modifiedTime,webViewLink)',
        }),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al listar archivos: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final filesList = data['files'] as List? ?? [];

      final files = <GoogleDriveFile>[];
      for (final fileData in filesList) {
        final mimeType = fileData['mimeType'] as String?;
        final name = fileData['name'] as String? ?? '';

        // Filtrar solo archivos de audio
        if (mimeType != null &&
            (mimeType.contains('audio') ||
                name.toLowerCase().endsWith('.mp3') ||
                name.toLowerCase().endsWith('.wav') ||
                name.toLowerCase().endsWith('.ogg') ||
                name.toLowerCase().endsWith('.flac') ||
                name.toLowerCase().endsWith('.aac') ||
                name.toLowerCase().endsWith('.m4a'))) {
          files.add(_mapToGoogleDriveFile(fileData));
        }
      }

      return files;
    } catch (e) {
      throw Exception('Error al listar archivos de Google Drive: $e');
    }
  }

  @override
  Future<String?> getDownloadUrl(String fileId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_apiBaseUrl/files/$fileId?fields=webViewLink,id,name'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al obtener URL de descarga: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['webViewLink'] as String?;
    } catch (e) {
      throw Exception('Error al obtener URL de descarga: $e');
    }
  }

  @override
  Future<GoogleDriveFile?> getFile(String fileId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_apiBaseUrl/files/$fileId?fields=*'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return _mapToGoogleDriveFile(data);
    } catch (e) {
      throw Exception('Error al obtener archivo: $e');
    }
  }

  /// Construye la consulta para filtrar archivos de audio
  String _buildQuery() {
    final parts = <String>[];

    // Filtrar por tipo de audio
    parts.add("mimeType contains 'audio/'");
    parts.add("name contains '.mp3' or name contains '.wav' or name contains '.ogg'");
    parts.add("name contains '.flac' or name contains '.aac' or name contains '.m4a'");

    // Filtrar por carpeta si se especificó
    if (folderId != null) {
      parts.add("'$folderId' in parents");
    }

    // Solo archivos no eliminados
    parts.add("trashed = false");

    return '(${parts.join(' or ')})';
  }

  /// Mapea un archivo de la API de Google Drive a GoogleDriveFile
  GoogleDriveFile _mapToGoogleDriveFile(Map<String, dynamic> file) {
    return GoogleDriveFile(
      id: file['id'] as String? ?? '',
      name: file['name'] as String? ?? 'Sin nombre',
      mimeType: file['mimeType'] as String? ?? 'application/octet-stream',
      size: (file['size'] as num?)?.toInt() ?? 0,
      createdTime: file['createdTime'] != null
          ? DateTime.parse(file['createdTime'] as String)
          : DateTime.now(),
      modifiedTime: file['modifiedTime'] != null
          ? DateTime.parse(file['modifiedTime'] as String)
          : DateTime.now(),
      downloadUrl: file['webViewLink'] as String?,
    );
  }

  @override
  Future<void> dispose() async {
    _httpClient.close();
  }
}