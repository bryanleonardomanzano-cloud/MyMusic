/// Repositorio implementa [MetadataDataSource].
/// Lee metadatos ID3 de archivos de audio MP3 locales.
library mymusic.features.metadata.data.metadata_repository;

import 'dart:convert';
import 'dart:io';

import 'package:mymusic/features/metadata/data/metadata_data_source.dart';
import 'package:mymusic/features/metadata/domain/metadata_state.dart';

/// Implementación de [MetadataDataSource] que lee metadatos ID3v1
/// de archivos de audio MP3 locales usando Dart puro.
class MetadataRepository implements MetadataDataSource {
  /// Tamaño del encabezado ID3v1 (últimos 128 bytes del archivo)
  static const int _id3v1TagSize = 128;

  /// Identificador del encabezado ID3v1
  static const List<int> _id3v1Header = [0x49, 0x44, 0x33]; // "ID3"

  @override
  Future<MetadataState> readMetadata({
    required String filePath,
  }) async {
    try {
      final file = File(filePath);

      // Verificar que el archivo exista
      if (!await file.exists()) {
        return MetadataState(
          filePath: filePath,
          error: 'El archivo no existe: $filePath',
        );
      }

      final fileSize = await file.length();

      // Si el archivo es menor a 128 bytes, no puede tener ID3v1
      if (fileSize < _id3v1TagSize) {
        return MetadataState(
          filePath: filePath,
          fileSize: fileSize,
          error: 'Archivo demasiado pequeño para contener metadatos ID3',
        );
      }

      // Leer los últimos 128 bytes del archivo (etiqueta ID3v1)
      final randomAccessFile = await file.open(mode: FileMode.read);
      await randomAccessFile.setPosition(fileSize - _id3v1TagSize);
      final tagBytes = await randomAccessFile.read(_id3v1TagSize);
      await randomAccessFile.close();

      // Verificar si tiene encabezado ID3v1
      if (tagBytes.length < 3 ||
          tagBytes[0] != _id3v1Header[0] ||
          tagBytes[1] != _id3v1Header[1] ||
          tagBytes[2] != _id3v1Header[2]) {
        return MetadataState(
          filePath: filePath,
          fileSize: fileSize,
          error: 'No se encontró etiqueta ID3v1 en el archivo',
        );
      }

      // Extraer campos del etiquetado ID3v1
      final title = _decodeId3v1Field(tagBytes, 3, 30);
      final artist = _decodeId3v1Field(tagBytes, 33, 30);
      final album = _decodeId3v1Field(tagBytes, 63, 30);
      final yearStr = _decodeId3v1Field(tagBytes, 93, 4);
      final trackNumber = tagBytes[126] > 0 ? tagBytes[126] : null;

      // Parsear año
      int? year;
      if (yearStr.isNotEmpty) {
        try {
          year = int.parse(yearStr);
        } catch (_) {
          year = null;
        }
      }

      return MetadataState(
        filePath: filePath,
        fileSize: fileSize,
        title: title.isEmpty ? null : title,
        artist: artist.isEmpty ? null : artist,
        album: album.isEmpty ? null : album,
        year: year,
        trackNumber: trackNumber,
        durationMs: null, // ID3v1 no almacena duración
        error: null,
      );
    } catch (e) {
      return MetadataState(
        filePath: filePath,
        error: 'Error al leer metadatos: $e',
      );
    }
  }

  @override
  Future<List<MetadataState>> readMultipleMetadata({
    required List<String> filePaths,
  }) async {
    final results = <MetadataState>[];
    for (final filePath in filePaths) {
      final metadata = await readMetadata(filePath: filePath);
      results.add(metadata);
    }
    return results;
  }

  @override
  Future<void> dispose() async {
    // No hay recursos que liberar en esta implementación
  }

  /// Decodificar un campo de texto del encabezado ID3v1
  /// Elimina bytes nulos y espacios en blanco al final
  String _decodeId3v1Field(List<int> bytes, int start, int length) {
    if (start + length > bytes.length) {
      return '';
    }

    final fieldBytes = bytes.sublist(start, start + length);

    // Eliminar bytes nulos al final
    int lastNonNull = fieldBytes.length - 1;
    while (lastNonNull >= 0 && fieldBytes[lastNonNull] == 0) {
      lastNonNull--;
    }

    if (lastNonNull < 0) {
      return '';
    }

    final trimmedBytes = fieldBytes.sublist(0, lastNonNull + 1);

    try {
      return utf8.decode(trimmedBytes).trim();
    } catch (_) {
      // Si falla la decodificación UTF-8, intentar Latin-1
      return latin1.decode(trimmedBytes).trim();
    }
  }
}