/// Política de reintentos con backoff exponencial.
/// Basado en: 3 intentos, tiempos 2s → 4s → 8s (2^n donde n = intento).
/// Lanza AppError.network al agotar reintentos.
import 'package:mymusic/core/errors/app_error.dart';
import 'package:mymusic/core/logging/app_logger.dart';

class RetryPolicy {
  final int maxAttempts;
  final Duration Function(int attempt)? getDelay;

  /// Constructor con valores por defecto: 3 intentos, backoff 2s-4s-8s.
  RetryPolicy({this.maxAttempts = 3, Duration Function(int)? getDelay})
      : this.getDelay = getDelay ?? _defaultDelay;

  static Duration _defaultDelay(int attempt) =>
      Duration(seconds: (2 << (attempt - 1))); // 2, 4, 8...

  /// Ejecuta la [fn] con reintentos. Retorna el resultado si éxito.
  /// Lanza AppError.network si falla después de maxAttempts.
  T execute<T>(T Function() fn) {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final result = fn();
        return result;
      } on Exception catch (_) {
        final delay = getDelay?.call(attempt) ?? _defaultDelay(attempt);
        AppLogger.d('Intento $attempt falló, reintentando en ${delay.inSeconds}s');
        if (attempt < maxAttempts) {
          Future.delayed(delay).then((_) {});
        } else {
          throw networkError('execute', 'Falló después de $maxAttempts intentos');
        }
      }
    }
    throw networkError('execute', 'Falló después de $maxAttempts intentos');
  }
}