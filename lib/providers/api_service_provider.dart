import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/api/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authToken = ref.watch(authTokenProvider);
  return ApiService(baseUrl: 'http://10.0.2.2:8000/', authToken: authToken);
});

// Example: you might also have an authTokenProvider
final authTokenProvider = StateProvider<String?>((ref) => null);
