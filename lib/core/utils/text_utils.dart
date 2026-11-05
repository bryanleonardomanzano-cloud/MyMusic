/// Utilidades de texto: normalización Unicode, fechas, duraciones, etc.
/// Solo Dart puro, sin dependencias Flutter (para ser usable en cualquier contexto).
class TextUtils {
  /// Normaliza un string para búsqueda: quita tildes, pasa a minúsculas, quita espacios extras.
  /// Ej: 'Álbum' → 'album', '  canción  ' → 'canción'
  static String normalizeForSearch(String? input) {
    if (input == null) return '';
    var s = input.trim();
    s = s.toLowerCase();
    // Sustituye caracteres acentuados por su versión simple
    s = s.replaceAll('á', 'a');
    s = s.replaceAll('é', 'e');
    s = s.replaceAll('í', 'i');
    s = s.replaceAll('ó', 'o');
    s = s.replaceAll('ú', 'u');
    s = s.replaceAll('ñ', 'n');
    s = s.replaceAll('Á', 'A');
    s = s.replaceAll('É', 'E');
    s = s.replaceAll('Í', 'I');
    s = s.replaceAll('Ó', 'O');
    s = s.replaceAll('Ú', 'U');
    s = s.replaceAll('Ñ', 'N');
    // Quita comodines múltiples
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s;
  }

  /// Formatea una duración en milisegundos a "mm:ss" o "h:mm:ss".
  static String formatDuration(int milliseconds) {
    final totalSeconds = milliseconds ~/ 1000;
    if (totalSeconds < 60) {
      return '${totalSeconds.remainder(60).toString().padLeft(2, '0')}s';
    }
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds.remainder(60);
    if (minutes < 60) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    final hours = minutes ~/ 60;
    final mins = minutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Convierte un string a un identificador válido (solo letras/números/guiones).
  /// Aplica el mismo reemplazo de tildes que normalizeForSearch para que
  /// 'Mi canción 2024!' → 'mi-cancion-2024'.
  static String toIdentifier(String input) {
    if (input == null) return '';
    var s = input.trim().toLowerCase();
    // Sustituye caracteres acentuados por su versión simple (misma lógica que normalizeForSearch)
    s = s.replaceAll('á', 'a');
    s = s.replaceAll('é', 'e');
    s = s.replaceAll('í', 'i');
    s = s.replaceAll('ó', 'o');
    s = s.replaceAll('ú', 'u');
    s = s.replaceAll('ñ', 'n');
    s = s.replaceAll('Á', 'A');
    s = s.replaceAll('É', 'E');
    s = s.replaceAll('Í', 'I');
    s = s.replaceAll('Ó', 'O');
    s = s.replaceAll('Ú', 'U');
    s = s.replaceAll('Ñ', 'N');
    s = s.replaceAll(RegExp(r'[^a-z0-9 ]'), '');
    s = s.replaceAll(RegExp(r'\s+'), '-');
    return s;
  }
}