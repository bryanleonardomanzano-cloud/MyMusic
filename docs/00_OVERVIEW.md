# MyMusic — Overview

## Objetivo
Reproductor musical privado tipo Spotify, con catálogo exclusivo de la colección en **Google Drive** del usuario. Plataformas: **Android, iOS, Windows**.

## Requisitos (confirmados por el cliente)
1. Login con Google (no guardar contraseñas, no servicios de pago).
2. Escaneo de audio en todo Drive con metadatos (artista/álbum/género).
3. Streaming directo desde Drive vía `fileId`/`accessToken` (sin copiar archivos a backend).
4. Modo offline (descargas organizadas).
5. Playlists + favoritos.
6. Reproducción en segundo plano.
7. Buscador.
8. UI oscura/moderma.
9. Regla dura: **nunca modificar ni eliminar archivos de Drive** — solo lectura (`drive.readonly` scope).

## Decisiones de arquitectura en 1 página
- **Clean Architecture + Feature-first vertical slices**: cada funcionalidad es un módulo independiente con su `domain\data\presentation`, comunicándose solo por interfaces.
- **Estado global**: Riverpod (DI + estado reactivo, modular y testeable).
- **Persistencia local**: `sqflite` + `sqflite_common_ffi` (Windows), DAO por entidad.
- **Reproductor**: `just_audio` (motor) + `audio_service`/`audioplayers` en fase Windows (background desktop limitado — ver Riesgos).
- **Drive**: `googleapis` (Drive v3 REST, tipado) + `google_sign_in`.

## Alcance de esta fase
Solo arquitectura y documentación. **Sin código funcional**, sin credenciales OAuth, sin `flutter create` aún.
