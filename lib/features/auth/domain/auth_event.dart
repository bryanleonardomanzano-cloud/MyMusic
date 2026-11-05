/// Eventos que pueden ocurrir en el módulo de autenticación.
abstract class AuthEvent {}

/// Evento de inicio de sesión con Google.
class GoogleLoginEvent extends AuthEvent {}

/// Evento de cierre de sesión.
class GoogleLogoutEvent extends AuthEvent {}

/// Evento de verificación de sesión existente (al iniciar la app).
class SessionCheckEvent extends AuthEvent {}