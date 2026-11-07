/// Read-only Google Drive API v3 access.
library mymusic.features.google_drive.data.google_drive_repository;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mymusic/features/google_drive/data/google_drive_data_source.dart';
import 'package:mymusic/features/google_drive/domain/google_drive_state.dart';

/// Supplies a fresh access token when needed. The auth SDK owns token renewal.
typedef DriveAccessTokenProvider = Future<String> Function(
    {bool forceRefresh});

class GoogleDriveRepository implements GoogleDriveDataSource {
  GoogleDriveRepository({
    required http.Client httpClient,
    required DriveAccessTokenProvider accessTokenProvider,
    this.folderId,
  })  : _httpClient = httpClient,
        _accessTokenProvider = accessTokenProvider;

  final http.Client _httpClient;
  final DriveAccessTokenProvider _accessTokenProvider;
  final String? folderId;

  static const String _apiBaseUrl = 'https://www.googleapis.com/drive/v3';
  static const Set<String> _audioExtensions = <String>{
    'mp3', 'flac', 'wav', 'aac', 'm4a', 'ogg', 'opus', 'wma', 'aiff', 'alac'
  };
  static const String _fields =
      'nextPageToken,files(id,name,mimeType,size,createdTime,modifiedTime,webViewLink)';

  /// Lists one Drive API page. With no folderId, Drive searches the whole
  /// account, including nested folders. With folderId, it lists direct children.
  @override
  Future<List<GoogleDriveFile>> listAudioFiles({
    int? pageSize,
    String? pageToken,
  }) async {
    final query = _audioQuery();
    final uri = Uri.parse('$_apiBaseUrl/files').replace(queryParameters: {
      'pageSize': (pageSize ?? 100).clamp(1, 1000).toString(),
      if (pageToken != null) 'pageToken': pageToken,
      'q': query,
      'orderBy': 'name',
      'fields': _fields,
      'supportsAllDrives': 'true',
      'includeItemsFromAllDrives': 'true',
    });
    final response = await _authorizedGet(uri);
    if (response.statusCode != 200) {
      throw _driveException('listar archivos', response);
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final files = decoded['files'] as List<dynamic>? ?? const [];
    return files
        .whereType<Map<String, dynamic>>()
        .map(_mapToGoogleDriveFile)
        .where((file) => file.isAudioFile)
        .toList(growable: false);
  }

  /// Retrieves every page of the account-wide audio search. Drive's files.list
  /// search covers nested folders, so this avoids one API call per directory.
  Future<List<GoogleDriveFile>> scanAudioFiles() async {
    final result = <GoogleDriveFile>[];
    String? pageToken;
    do {
      final uri = Uri.parse('$_apiBaseUrl/files').replace(queryParameters: {
        'pageSize': '1000',
        if (pageToken != null) 'pageToken': pageToken,
        'q': _audioQuery(),
        'orderBy': 'name',
        'fields': _fields,
        'supportsAllDrives': 'true',
        'includeItemsFromAllDrives': 'true',
      });
      final response = await _authorizedGet(uri);
      if (response.statusCode != 200) {
        throw _driveException('analizar la biblioteca', response);
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final files = decoded['files'] as List<dynamic>? ?? const [];
      result.addAll(files
          .whereType<Map<String, dynamic>>()
          .map(_mapToGoogleDriveFile)
          .where((file) => file.isAudioFile));
      pageToken = decoded['nextPageToken'] as String?;
    } while (pageToken != null && pageToken.isNotEmpty);
    return result;
  }

  @override
  Future<String?> getDownloadUrl(String fileId) async {
    // La URL necesita el header Authorization: Bearer <token> al usarse.
    // No se incluye ni persiste el token en la URL.
    final uri = Uri.parse('$_apiBaseUrl/files/${Uri.encodeComponent(fileId)}')
        .replace(queryParameters: const {'alt': 'media'});
    return uri.toString();
  }

  @override
  Future<GoogleDriveFile?> getFile(String fileId) async {
    final uri = Uri.parse('$_apiBaseUrl/files/${Uri.encodeComponent(fileId)}')
        .replace(queryParameters: const {
      'fields': 'id,name,mimeType,size,createdTime,modifiedTime,webViewLink',
      'supportsAllDrives': 'true',
    });
    final response = await _authorizedGet(uri);
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw _driveException('obtener archivo', response);
    }
    return _mapToGoogleDriveFile(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<http.Response> _authorizedGet(Uri uri) async {
    var token = await _accessTokenProvider(forceRefresh: false);
    var response = await _httpClient.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 401) {
      token = await _accessTokenProvider(forceRefresh: true);
      response = await _httpClient.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
    }
    return response;
  }

  String _audioQuery() {
    final extensions = _audioExtensions
        .map((extension) => "name contains '.$extension'")
        .join(' or ');
    final audioPredicate = "mimeType contains 'audio/' or $extensions";
    final parentPredicate = folderId == null
        ? ''
        : " and '${folderId!.replaceAll("'", r"\'")}' in parents";
    return 'trashed = false and ($audioPredicate)$parentPredicate';
  }

  GoogleDriveFile _mapToGoogleDriveFile(Map<String, dynamic> file) {
    final now = DateTime.now();
    return GoogleDriveFile(
      id: file['id'] as String? ?? '',
      name: file['name'] as String? ?? 'Sin nombre',
      mimeType: file['mimeType'] as String? ?? 'application/octet-stream',
      size: (file['size'] as num?)?.toInt() ?? 0,
      createdTime: DateTime.tryParse(file['createdTime'] as String? ?? '') ?? now,
      modifiedTime:
          DateTime.tryParse(file['modifiedTime'] as String? ?? '') ?? now,
      downloadUrl: file['webViewLink'] as String?,
    );
  }

  Exception _driveException(String operation, http.Response response) =>
      Exception('Error al $operation en Google Drive (${response.statusCode}).');

  @override
  Future<void> dispose() async => _httpClient.close();
}
