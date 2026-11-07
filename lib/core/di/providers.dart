import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mymusic/core/errors/app_error.dart';
import 'package:mymusic/core/logging/app_logger.dart';
import 'package:mymusic/core/network/retry_policy.dart';
import 'package:mymusic/core/utils/text_utils.dart';
import 'package:mymusic/features/auth/data/google_sign_in_data_source.dart';
import 'package:mymusic/features/auth/domain/auth_repository.dart';
import 'package:mymusic/features/auth/domain/auth_state.dart';
import 'package:mymusic/features/auth/presentation/auth_notifier.dart';
import 'package:mymusic/features/google_drive/data/google_drive_data_source.dart';
import 'package:mymusic/features/google_drive/data/google_drive_repository.dart';

final loggerProvider = Provider<AppLogger>((ref) => AppLogger());
final textUtilsProvider = Provider<TextUtils>((ref) => TextUtils());
final retryPolicyProvider = Provider<RetryPolicy>(
    (ref) => RetryPolicy(maxAttempts: 3));

final authDataSourceProvider = Provider<GoogleSignInDataSource>(
    (ref) => GoogleSignInDataSource());

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => ref.watch(authDataSourceProvider));

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(_repository: ref.watch(authRepositoryProvider));
});

final googleDriveDataSourceProvider = Provider<GoogleDriveDataSource>((ref) {
  final auth = ref.watch(authDataSourceProvider);
  final repository = GoogleDriveRepository(
    httpClient: http.Client(),
    accessTokenProvider: auth.getAccessToken,
  );
  ref.onDispose(repository.dispose);
  return repository;
});
