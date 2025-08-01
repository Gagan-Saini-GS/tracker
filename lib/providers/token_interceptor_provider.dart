import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/api/token_interceptor.dart';
import 'package:tracker/providers/auth_token_provider.dart';

final tokenInterceptorProvider = Provider<TokenInterceptor>((ref) {
  final authTokenStorage = ref.watch(authTokenStorageProvider);
  return TokenInterceptor(
    authTokenStorage: authTokenStorage,
    baseUrl: 'http://10.0.2.2:8000/',
  );
});
