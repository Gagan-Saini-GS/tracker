import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/api/api_service.dart';
import 'package:tracker/utils/config.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authToken = ref.watch(authTokenProvider);
  return ApiService(baseUrl: AppConfig.serverBaseUrl, authToken: authToken);
});

// Example: you might also have an authTokenProvider
final authTokenProvider = StateProvider<String?>((ref) => null);
