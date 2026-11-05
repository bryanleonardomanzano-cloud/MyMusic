/// Entidad que representa el estado de la sesión de usuario tras el login.
class AuthUser {
  final String id; // email o uid de Google
  final String email;
  final String? displayName;
  final DateTime lastLogin;
  final bool isFavorite; // futuras listas de favoritos a nivel de usuario

  AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    DateTime? lastLogin,
    this.isFavorite = false,
  }) : lastLogin = lastLogin ?? DateTime.now();

  factory AuthUser.fromGoogle(Map<String, dynamic> googleUser) {
    return AuthUser(
      id: googleUser['id'] ?? '',
      email: googleUser['email'] ?? '',
      displayName: googleUser['displayName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'lastLogin': lastLogin.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}