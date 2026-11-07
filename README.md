# MyMusic

Reproductor musical personal para Android, iOS y Windows, con Google Drive como fuente privada de archivos. La aplicación solicita solo lectura y no modifica los originales.

## Estado y alcance de esta entrega

Esta rama añade inicio de sesión Google y acceso de lectura a Drive para Android/iOS: solicita `drive.readonly`, obtiene access tokens desde el SDK nativo al hacer peticiones, vuelve a obtener uno al recibir HTTP 401 y busca archivos de audio por páginas en toda la cuenta (incluidas unidades compartidas accesibles). La pantalla inicial permite iniciar sesión, cerrar sesión y analizar/mostrar los archivos encontrados.

No se guarda contraseña, refresh token ni access token en preferencias. `google_sign_in` gestiona la sesión y la obtención/renovación del access token; el plugin no expone un `refresh_token` OAuth en este flujo. El permiso de Drive se pide después de elegir cuenta. La aplicación nunca usa endpoints de escritura o eliminación.

**Aún pendiente:** reproducción de archivos Drive, metadatos embebidos, SQLite/indexación, descarga offline, cola/audio en segundo plano, UI completa y configuración OAuth por plataforma. La versión actual solo enumera los archivos encontrados.

## Plataformas y requisito de configuración

El `google_sign_in` fijado en este proyecto da soporte al flujo nativo de Android/iOS; Windows requiere un flujo OAuth de escritorio diferente y todavía no puede iniciar sesión desde esta pantalla. No pegues client secrets en el código ni en el repositorio.

En Google Cloud Console, con una cuenta personal:

1. Crea/elige un proyecto y habilita **Google Drive API**.
2. Configura la pantalla de consentimiento OAuth y agrega tu cuenta como usuario de prueba si la app está en pruebas.
3. Crea los clientes OAuth adecuados para Android (paquete + SHA-1/SHA-256) y iOS (Bundle ID); configura los archivos/plist de plataforma que exige `google_sign_in`.
4. Comprueba que la cuenta autoriza el alcance `https://www.googleapis.com/auth/drive.readonly`.
5. Ejecuta en la raíz: `flutter pub get`, `flutter analyze` y `flutter test`.

Google ofrece cuotas de API sujetas a sus políticas y cambios. Esta aplicación no requiere un backend, suscripción o publicidad de pago; no se puede prometer que las cuotas o políticas gratuitas de Google sean inmutables.

## Privacidad y límites

- MyMusic solo solicita el alcance OAuth de lectura de Drive.
- Las llamadas usan `files.list` y `files.get`; no se implementan `create`, `update`, `delete`, movimiento ni renombrado.
- No registres access tokens en logs ni los incluyas en URLs.
- `getDownloadUrl` devuelve la ruta `alt=media`; quien la use debe adjuntar el bearer token como header.
- Los permisos a archivos compartidos siguen sujetos a la cuenta y a Google Drive.

## Verificación

Se añadieron pruebas unitarias del repositorio Drive para filtro, cabecera de autorización, reintento tras 401 y paginación. No se afirma que estas pruebas hayan sido ejecutadas en este entorno. Ejecuta `flutter pub get && flutter analyze && flutter test` con Flutter instalado y configura credenciales OAuth reales antes de probar el login en un dispositivo.
