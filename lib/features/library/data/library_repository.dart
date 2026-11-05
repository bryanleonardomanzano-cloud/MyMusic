/// Repositorio implementa [LibraryDataSource].
/// Entrega instancias de [Song] y [Playlist] desde la biblioteca.
/// Esta versión usa datos simulados (mock); la implementación completa
/// integrará con Google Drive o una base de datos local SQLite.
library mymusic.features.library.data.library_repository;

import 'package:mymusic/features/library/data/library_data_source.dart';
import 'package:mymusic/features/library/domain/library_state.dart';

class LibraryRepository implements LibraryDataSource {
  /// Catálogo simulado de canciones en la biblioteca
  final List<Song> _mockSongs = [
    Song(
      id: 'song_001',
      title: 'Mi canción favorita',
      artist: 'Artista Uno',
      album: 'Álbum Principal',
      genre: 'Pop',
      durationMs: 240000,
      filePath: 'assets/audio/song_001.mp3',
      addedAt: DateTime(2024, 1, 15),
    ),
    Song(
      id: 'song_002',
      title: 'Canción de verano',
      artist: 'Artista Dos',
      album: 'Éxitos 2024',
      genre: 'Pop',
      durationMs: 180000,
      filePath: 'assets/audio/song_002.mp3',
      addedAt: DateTime(2024, 2, 20),
    ),
    Song(
      id: 'song_003',
      title: 'Balada romántica',
      artist: 'Artista Tres',
      album: 'Amor y Pasión',
      genre: 'Balada',
      durationMs: 300000,
      filePath: 'assets/audio/song_003.mp3',
      addedAt: DateTime(2024, 3, 10),
    ),
    Song(
      id: 'song_004',
      title: 'Rock energético',
      artist: 'Banda Roca',
      album: 'Potencia',
      genre: 'Rock',
      durationMs: 210000,
      filePath: 'assets/audio/song_004.mp3',
      addedAt: DateTime(2024, 4, 5),
    ),
    Song(
      id: 'song_005',
      title: 'Jazz nocturno',
      artist: 'Músico Jazz',
      album: 'Noches de Jazz',
      genre: 'Jazz',
      durationMs: 270000,
      filePath: 'assets/audio/song_005.mp3',
      addedAt: DateTime(2024, 5, 12),
    ),
  ];

  /// Playlists simuladas
  final List<Playlist> _mockPlaylists = [
    Playlist(
      id: 'playlist_001',
      name: 'Mis Favoritas',
      description: 'Las mejores canciones',
      songIds: ['song_001', 'song_003'],
      createdAt: DateTime(2024, 1, 20),
    ),
    Playlist(
      id: 'playlist_002',
      name: 'Para Ejercitarme',
      description: 'Música con energía',
      songIds: ['song_004'],
      createdAt: DateTime(2024, 2, 10),
    ),
  ];

  @override
  Future<List<Song>> getSongs() async {
    // Simular latencia de red/disco
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_mockSongs);
  }

  @override
  Future<List<Playlist>> getPlaylists() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_mockPlaylists);
  }

  @override
  Future<void> addSong(Song song) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockSongs.add(song);
  }

  @override
  Future<void> removeSong(String songId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockSongs.removeWhere((song) => song.id == songId);
    // También remover de todas las playlists
    for (final playlist in _mockPlaylists) {
      playlist.songIds.remove(songId);
    }
  }

  @override
  Future<void> createPlaylist(Playlist playlist) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockPlaylists.add(playlist);
  }

  @override
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final playlistIndex = _mockPlaylists.indexWhere(
      (p) => p.id == playlistId,
    );
    if (playlistIndex != -1) {
      final playlist = _mockPlaylists[playlistIndex];
      if (!playlist.songIds.contains(songId)) {
        _mockPlaylists[playlistIndex] = Playlist(
          id: playlist.id,
          name: playlist.name,
          description: playlist.description,
          songIds: [...playlist.songIds, songId],
          createdAt: playlist.createdAt,
        );
      }
    }
  }

  @override
  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final playlistIndex = _mockPlaylists.indexWhere(
      (p) => p.id == playlistId,
    );
    if (playlistIndex != -1) {
      final playlist = _mockPlaylists[playlistIndex];
      _mockPlaylists[playlistIndex] = Playlist(
        id: playlist.id,
        name: playlist.name,
        description: playlist.description,
        songIds: playlist.songIds.where((id) => id != songId).toList(),
        createdAt: playlist.createdAt,
      );
    }
  }

  @override
  Future<List<Song>> searchSongs(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) {
      return List.unmodifiable(_mockSongs);
    }

    final lowerQuery = query.toLowerCase();
    return _mockSongs
        .where((song) =>
            song.title.toLowerCase().contains(lowerQuery) ||
            song.artist.toLowerCase().contains(lowerQuery) ||
            (song.album != null && song.album!.toLowerCase().contains(lowerQuery)) ||
            (song.genre != null && song.genre!.toLowerCase().contains(lowerQuery)))
        .toList();
  }

  @override
  Future<void> dispose() async {
    // No hay recursos que liberar en esta implementación mock
  }
}