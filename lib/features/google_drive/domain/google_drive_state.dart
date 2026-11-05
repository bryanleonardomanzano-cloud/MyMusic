/// Estado del módulo de Google Drive.
/// Contiene la información de archivos de audio disponibles en Google Drive.
library mymusic.features.google_drive.domain.google_drive_state;

/// Estado del módulo de Google Drive.
class GoogleDriveState {
  /// Lista de archivos de audio disponibles en Google Drive
  final List<GoogleDriveFile> files;

  /// Archivo actualmente seleccionado para reproducir
  final GoogleDriveFile? selectedFile;

  /// Indica si se está cargando la lista de archivos
  final bool isLoading;

  /// Mensaje de error si ocurrió uno
  final String? error;

  /// Constructor
  GoogleDriveState({
    this.files = const [],
    this.selectedFile,
    this.isLoading = false,
    this.error,
  });

  /// Estado inicial vacío
  static final GoogleDriveState initial = GoogleDriveState();

  /// Crea una copia con campos actualizados
  GoogleDriveState copyWith({
    List<GoogleDriveFile>? files,
    GoogleDriveFile? selectedFile,
    bool? isLoading,
    String? error,
  }) {
    return GoogleDriveState(
      files: files ?? this.files,
      selectedFile: selectedFile ?? this.selectedFile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Cantidad total de archivos en Google Drive
  int get fileCount => files.length;

  @override
  String toString() {
    if (error != null) return 'GoogleDriveState.error(message: $error)';
    if (isLoading) return 'GoogleDriveState.loading';
    return 'GoogleDriveState(files: $fileCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoogleDriveState &&
        other.files == files &&
        other.selectedFile == selectedFile &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(files, selectedFile, isLoading, error);
}

/// Representa un archivo de audio en Google Drive
class GoogleDriveFile {
  /// ID único del archivo en Google Drive
  final String id;

  /// Nombre del archivo
  final String name;

  /// Tipo MIME del archivo
  final String mimeType;

  /// Tamaño del archivo en bytes
  final int size;

  /// Fecha de creación en Google Drive
  final DateTime createdTime;

  /// Fecha de última modificación
  final DateTime modifiedTime;

  /// URL de descarga directa (opcional)
  final String? downloadUrl;

  /// Constructor
  GoogleDriveFile({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.size,
    required this.createdTime,
    required this.modifiedTime,
    this.downloadUrl,
  });

  /// Indica si el archivo es un archivo de audio
  bool get isAudioFile {
    return mimeType.contains('audio') ||
        name.toLowerCase().endsWith('.mp3') ||
        name.toLowerCase().endsWith('.wav') ||
        name.toLowerCase().endsWith('.ogg') ||
        name.toLowerCase().endsWith('.flac') ||
        name.toLowerCase().endsWith('.aac') ||
        name.toLowerCase().endsWith('.m4a');
  }

  @override
  String toString() {
    return 'GoogleDriveFile(name: $name, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoogleDriveFile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}