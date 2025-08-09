import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/api/token_interceptor.dart';
import 'package:tracker/providers/auth_token_provider.dart';
import 'package:tracker/utils/config.dart';

final tokenInterceptorProvider = Provider<TokenInterceptor>((ref) {
  final authTokenStorage = ref.watch(authTokenStorageProvider);
  return TokenInterceptor(
    authTokenStorage: authTokenStorage,
    baseUrl: AppConfig.serverBaseUrl,
  );
});
