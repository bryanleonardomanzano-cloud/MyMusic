/// Errores categorizados de la aplicación.
/// Se usa Result<T> = Success(data) | Failure(AppError) en todo el código.
class AppError {
  final String code;
  final String message;
  final dynamic extra;

  AppError(this.code, this.message, [this.extra]);

  /// Constructor de conveniencia: error desconocido.
  factory AppError.unknown([String message = 'Error desconocido']) =>
      AppError('unknown', message);

  @override
  String toString() => 'AppError($code): $message';
}

/// Monádica de resultados: Success o Failure.
class Result<T> {
  final T? value;
  final AppError? error;

  const Result.ok(T value) : value = value, error = null;
  const Result.err(AppError error) : value = null, error = error;

  bool get isOk => error == null;
  bool get isErr => error != null;

  /// Retorna el valor o lanza el error.
  T valueOrThrow() {
    if (isOk) return value!;
    throw error ?? Exception('Result is an error');
  }
}

/// Códigos de error estándares.
abstract class ErrorCodes {
  static const String unknown = 'unknown';
  static const String auth = 'auth';
  static const String network = 'network';
  static const String drive = 'drive';
  static const String storage = 'storage';
  static const String player = 'player';
  static const String metadata = 'metadata';
  static const String offline = 'offline';
}

/// Helper para crear errores tipados (funciones top-level).
AppError networkError(String operation, [dynamic cause]) =>
    AppError('network.$operation', 'Error de red', cause);

AppError authError(String operation, [dynamic cause]) =>
    AppError('auth.$operation', 'Error de autenticación', cause);

AppError driveError(String operation, [dynamic cause]) =>
    AppError('drive.$operation', 'Error de Google Drive', cause);

AppError storageError(String operation, [dynamic cause]) =>
    AppError('storage.$operation', 'Error de almacenamiento', cause);

AppError playerError(String operation, [dynamic cause]) =>
    AppError('player.$operation', 'Error de reproducción', cause);

AppError metadataError(String operation, [dynamic cause]) =>
    AppError('metadata.$operation', 'Error al leer metadatos', cause);

AppError offlineError(String operation, [dynamic cause]) =>
    AppError('offline.$operation', 'Error en operaciones offline', cause);