import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mymusic/core/di/providers.dart';
import 'package:mymusic/features/auth/domain/auth_state.dart';
import 'package:mymusic/features/google_drive/data/google_drive_repository.dart';
import 'package:mymusic/features/google_drive/domain/google_drive_state.dart';

void main() => runApp(const ProviderScope(child: MyMusicApp()));

class MyMusicApp extends StatelessWidget {
  const MyMusicApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'MyMusic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF090B0A),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFB8F36B),
            surface: Color(0xFF121513),
          ),
          useMaterial3: true,
        ),
        home: const DriveHomeScreen(),
      );
}

class DriveHomeScreen extends ConsumerStatefulWidget {
  const DriveHomeScreen({super.key});

  @override
  ConsumerState<DriveHomeScreen> createState() => _DriveHomeScreenState();
}

class _DriveHomeScreenState extends ConsumerState<DriveHomeScreen> {
  List<GoogleDriveFile> _files = const [];
  bool _isScanning = false;
  String? _scanError;

  Future<void> _signIn() async {
    await ref.read(authProvider.notifier).login();
  }

  Future<void> _signOut() async {
    setState(() {
      _files = const [];
      _scanError = null;
    });
    await ref.read(authProvider.notifier).logout();
  }

  Future<void> _scanDrive() async {
    setState(() {
      _isScanning = true;
      _scanError = null;
    });
    try {
      final source = ref.read(googleDriveDataSourceProvider);
      final files = source is GoogleDriveRepository
          ? await source.scanAudioFiles()
          : await _scanPages(source);
      if (mounted) setState(() => _files = files);
    } catch (error) {
      if (mounted) setState(() => _scanError = error.toString());
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<List<GoogleDriveFile>> _scanPages(source) async {
    final all = <GoogleDriveFile>[];
    String? pageToken;
    do {
      final page = await source.listAudioFiles(pageSize: 1000, pageToken: pageToken);
      all.addAll(page);
      // Generic interface does not expose Drive's nextPageToken yet.
      pageToken = null;
    } while (pageToken != null);
    return all;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 760;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyMusic'),
        actions: [
          if (authState is AuthAuthenticated)
            IconButton(
              tooltip: 'Cerrar sesión',
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: switch (authState) {
              AuthAuthenticated(:final user) => _buildLibrary(user, isDesktop),
              AuthError(:final error) => _buildLogin(error.message),
              _ => _buildLogin(null),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogin(String? error) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.graphic_eq, size: 58, color: Color(0xFFB8F36B)),
          const SizedBox(height: 18),
          const Text('Tu música, desde Google Drive',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Text(
            'Inicia sesión y concede el permiso de solo lectura para explorar tus archivos de audio. MyMusic no cambia ni elimina archivos de Drive.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            Text(error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.orangeAccent)),
          ],
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _signIn,
            icon: const Icon(Icons.login),
            label: const Text('Continuar con Google'),
          ),
          const SizedBox(height: 14),
          const Text(
            'El acceso a Drive está en esta versión para Android e iOS. Windows necesita configurar OAuth de escritorio.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      );

  Widget _buildLibrary(AuthUser user, bool isDesktop) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hola, ${user.displayName ?? user.email}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
          const SizedBox(height: 7),
          const Text('Drive conectado · permiso de solo lectura',
              style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _isScanning ? null : _scanDrive,
            icon: _isScanning
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: Text(_isScanning ? 'Analizando Drive…' : 'Analizar mi música'),
          ),
          if (_scanError != null) ...[
            const SizedBox(height: 15),
            Text(_scanError!, style: const TextStyle(color: Colors.orangeAccent)),
          ],
          const SizedBox(height: 18),
          Text('${_files.length} archivos de audio',
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Expanded(
            child: _files.isEmpty
                ? Center(
                    child: Text(
                      _isScanning
                          ? 'Buscando en tu Drive…'
                          : 'Pulsa “Analizar mi música” para empezar.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.separated(
                    itemCount: _files.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final file = _files[index];
                      return ListTile(
                        leading: const Icon(Icons.music_note,
                            color: Color(0xFFB8F36B)),
                        title: Text(file.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                            '${file.mimeType} · ${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB'),
                        trailing: isDesktop
                            ? const Icon(Icons.cloud_done_outlined)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      );
}
