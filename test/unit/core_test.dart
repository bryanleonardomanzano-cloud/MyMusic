import 'package:mymusic/core/errors/app_error.dart';
import 'package:mymusic/core/logging/app_logger.dart';
import 'package:mymusic/core/network/retry_policy.dart';
import 'package:mymusic/core/utils/text_utils.dart';
import 'package:test/test.dart';

void main() {
  // --- AppError ---
  group('AppError', () {
    test('constructor principal con code y message', () {
      final e = AppError('unknown', 'msg');
      expect(e.code, equals('unknown'));
      expect(e.message, equals('msg'));
    });

    test('factory unknown con mensaje opcional', () {
      final e = AppError.unknown('msg personalizado');
      expect(e.code, equals('unknown'));
      expect(e.message, equals('msg personalizado'));
    });

    test('errores tipados mediante funciones top-level', () {
      final net = networkError('testOp', 'causa opcional');
      final auth = authError('login', 'credenciales invalidas');
      final drive = driveError('listFiles', 'no permissions');
      final storage = storageError('download', 'space full');
      final player = playerError('play', 'track not found');
      final meta = metadataError('parse', 'id3 missing');
      final offline = offlineError('resume', 'interrupted');

      expect(net.code, startsWith('network.'));
      expect(auth.code, startsWith('auth.'));
      expect(drive.code, startsWith('drive.'));
      expect(storage.code, startsWith('storage.'));
      expect(player.code, startsWith('player.'));
      expect(meta.code, startsWith('metadata.'));
      expect(offline.code, startsWith('offline.'));
    });

    test('AppError toString devuelve formato esperado', () {
      final e = AppError('test', 'msg');
      expect(e.toString(), contains('AppError'));
      expect(e.toString(), contains('msg'));
    });
  });

  // --- Result ---
  group('Result', () {
    test('Result.ok debe tener valor y no error', () {
      final r = Result.ok(42);
      expect(r.isOk, isTrue);
      expect(r.isErr, isFalse);
      expect(r.value, equals(42));
      expect(r.error, isNull);
    });

    test('Result.err debe tener error y no valor', () {
      final e = AppError('err', 'msg');
      final r = Result.err(e);
      expect(r.isOk, isFalse);
      expect(r.isErr, isTrue);
      expect(r.value, isNull);
      expect(r.error, equals(e));
    });

    test('Result.valueOrThrow debe lanzar si es error', () {
      final e = AppError('err', 'msg');
      final r = Result.err(e);
      expect(() => r.valueOrThrow(), throwsA(isA<AppError>()));
    });

    test('Result.valueOrThrow debe devolver valor si es ok', () {
      final r = Result.ok('hola');
      expect(r.valueOrThrow(), equals('hola'));
    });
  });

  // --- TextUtils ---
  group('TextUtils', () {
    test('normalizeForSearch debe quitar tildes y pasar a minúsculas', () {
      final result = TextUtils.normalizeForSearch('Álbum - Canción');
      expect(result, equals('album - cancion'));
    });

    test('normalizeForSearch null debe retornar vacío', () {
      final result = TextUtils.normalizeForSearch(null);
      expect(result, equals(''));
    });

    test('formatDuration debe formatear 180000ms a "03:00"', () {
      final formatted = TextUtils.formatDuration(180000);
      expect(formatted, equals('03:00'));
    });

    test('formatDuration menos de 60s', () {
      final formatted = TextUtils.formatDuration(45000); // 45s
      expect(formatted, equals('45s'));
    });

    test('toIdentifier debe dejar solo letras/numeros y guiones', () {
      final id = TextUtils.toIdentifier('Mi canción 2024!');
      expect(id, equals('mi-cancion-2024'));
    });
  });

  // --- RetryPolicy ---
  group('RetryPolicy', () {
    test('execute debe retornar éxito en el primer intento', () {
      final policy = RetryPolicy(maxAttempts: 3);
      int called = 0;

      final result = policy.execute(() {
        called++;
        return 123;
      });

      expect(called, equals(1));
      expect(result, equals(123));
    });

    test('execute debe reintentar y al fin fallar con AppError.network', () {
      final policy = RetryPolicy(maxAttempts: 3);

      // Cada llamada falla
      try {
        policy.execute(() {
          throw Exception('siempre falla');
        });
      } catch (e) {
        // se esperaba el error
        expect(e, isA<AppError>());
        expect((e as AppError).code, startsWith('network'));
      }
    });

    test('execute con 3 intentos agota todos', () async {
      final policy = RetryPolicy(maxAttempts: 3);
      final attempts = <int>[];

      try {
        policy.execute(() {
          attempts.add(1);
          throw Exception('fallo');
        });
      } catch (_) {
        // esperado
      }

      // Se hicieron 3 intentos
      expect(attempts.length, equals(3));
    });
  });
}