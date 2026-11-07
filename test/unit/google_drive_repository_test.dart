import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mymusic/features/google_drive/data/google_drive_repository.dart';

void main() {
  group('GoogleDriveRepository', () {
    test('lists audio using read-only bearer token and filters non-audio', () async {
      Uri? requestedUri;
      String? authorization;
      final client = MockClient((request) async {
        requestedUri = request.url;
        authorization = request.headers['Authorization'];
        return http.Response(jsonEncode({
          'files': [
            {
              'id': 'song-1',
              'name': 'Song.mp3',
              'mimeType': 'application/octet-stream',
              'size': '2048',
            },
            {
              'id': 'doc-1',
              'name': 'notes.txt',
              'mimeType': 'text/plain',
            }
          ]
        }), 200);
      });
      final repository = GoogleDriveRepository(
        httpClient: client,
        accessTokenProvider: ({bool forceRefresh = false}) async => 'token',
      );

      final files = await repository.listAudioFiles();
      expect(files, hasLength(1));
      expect(files.single.id, 'song-1');
      expect(authorization, 'Bearer token');
      expect(requestedUri!.queryParameters['supportsAllDrives'], 'true');
      expect(requestedUri!.queryParameters['q'], contains("trashed = false"));
      await repository.dispose();
    });

    test('reacquires a token once after an unauthorized response', () async {
      var calls = 0;
      var tokenRequests = 0;
      final client = MockClient((request) async {
        calls++;
        if (calls == 1) return http.Response('{}', 401);
        expect(request.headers['Authorization'], 'Bearer fresh-token');
        return http.Response(jsonEncode({'files': []}), 200);
      });
      final repository = GoogleDriveRepository(
        httpClient: client,
        accessTokenProvider: ({bool forceRefresh = false}) async {
          tokenRequests++;
          return forceRefresh ? 'fresh-token' : 'old-token';
        },
      );

      expect(await repository.listAudioFiles(), isEmpty);
      expect(calls, 2);
      expect(tokenRequests, 2);
      await repository.dispose();
    });

    test('scanAudioFiles follows every Drive page', () async {
      var calls = 0;
      final client = MockClient((request) async {
        calls++;
        if (request.url.queryParameters['pageToken'] == null) {
          return http.Response(jsonEncode({
            'nextPageToken': 'next',
            'files': [
              {'id': 'one', 'name': 'one.flac', 'mimeType': 'audio/flac'}
            ]
          }), 200);
        }
        return http.Response(jsonEncode({
          'files': [
            {'id': 'two', 'name': 'two.m4a', 'mimeType': 'audio/mp4'}
          ]
        }), 200);
      });
      final repository = GoogleDriveRepository(
        httpClient: client,
        accessTokenProvider: ({bool forceRefresh = false}) async => 'token',
      );

      final files = await repository.scanAudioFiles();
      expect(calls, 2);
      expect(files.map((file) => file.id), ['one', 'two']);
      await repository.dispose();
    });
  });
}
