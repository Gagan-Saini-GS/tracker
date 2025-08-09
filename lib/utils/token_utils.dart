import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tracker/providers/auth_token_provider.dart';
import 'package:tracker/providers/refresh_token_provider.dart';

class TokenUtils {
  static Future<bool> validateAndRefreshTokenIfNeeded(WidgetRef ref) async {
    try {
      final authTokenStorage = ref.read(authTokenStorageProvider);
      final accessToken = await authTokenStorage.getToken();
      final refreshToken = await authTokenStorage.getRefreshToken();

      // If no tokens exist, user needs to login
      if (accessToken == null || refreshToken == null) {
        return false;
      }

      // For now, we'll assume the token is valid if it exists
      // In a real app, you might want to decode the JWT and check expiration
      // For now, we'll let the API calls handle token refresh automatically
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> refreshToken(WidgetRef ref) async {
    try {
      final refreshNotifier = ref.read(refreshTokenProvider.notifier);
      await refreshNotifier.refreshToken();
    } catch (e) {
      Logger().e(e);
    }
  }

  static Future<void> clearAllTokens(WidgetRef ref) async {
    try {
      final authTokenStorage = ref.read(authTokenStorageProvider);
      await authTokenStorage.clearAllTokens();
    } catch (e) {
      Logger().e(e);
    }
  }
}
