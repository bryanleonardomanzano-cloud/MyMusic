/// Logger simple y modular para toda la aplicación.
/// Usa stdout con formato de fecha/hora; en producción se puede reemplazar
/// por flutter_secure_storage + logs remotos o servicio tipo Firebase Crashlytics.
class AppLogger {
  static const _pattern = '[yyyy-MM-dd HH:mm:ss]';

  /// Línea con marca de tiempo.
  static void d(String message, {String? component}) {
    final now = DateTime.now();
    final tag = component != null ? '[$component]' : '';
    print('[$_formatDate(now)] $tag $message');
  }

  static void e(dynamic error, {String? component, String? message}) {
    final now = DateTime.now();
    final tag = component != null ? '[$component]' : '';
    final msg = message != null ? '$message: ' : '';
    print('[ERROR $_formatDate(now)] $tag $msg$error');
  }

  static String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';

  /// Para tests: capturar log y retornar string (opcional).
  static String? capture() => null; // En producción real podría retornar lo impreso.
}