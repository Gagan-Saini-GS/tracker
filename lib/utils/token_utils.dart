import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/auth_token_provider.dart';
import 'package:tracker/providers/refresh_token_provider.dart';
import 'package:tracker/storage/auth_token_storage.dart';

class TokenUtils {
  static Future<bool> validateAndRefreshTokenIfNeeded(WidgetRef ref) async {
    try {
      final authTokenStorage = ref.read(authTokenStorageProvider);
      final accessToken = await authTokenStorage.getToken();
      final refreshToken = await authTokenStorage.getRefreshToken();

      // If no tokens exist, user needs to login
      if (accessToken == null || refreshToken == null) {
        debugPrint('No tokens found, user needs to login');
        return false;
      }

      // For now, we'll assume the token is valid if it exists
      // In a real app, you might want to decode the JWT and check expiration
      // For now, we'll let the API calls handle token refresh automatically
      debugPrint('Tokens found, proceeding with app');
      return true;
    } catch (e) {
      debugPrint('Error validating tokens: $e');
      return false;
    }
  }

  static Future<void> refreshToken(WidgetRef ref) async {
    try {
      final refreshNotifier = ref.read(refreshTokenProvider.notifier);
      final success = await refreshNotifier.refreshToken();

      if (success) {
        debugPrint('Token refreshed successfully');
      } else {
        debugPrint('Token refresh failed');
      }
    } catch (e) {
      debugPrint('Error during token refresh: $e');
    }
  }

  static Future<void> clearAllTokens(WidgetRef ref) async {
    try {
      final authTokenStorage = ref.read(authTokenStorageProvider);
      await authTokenStorage.clearAllTokens();
      debugPrint('All tokens cleared');
    } catch (e) {
      debugPrint('Error clearing tokens: $e');
    }
  }
}
