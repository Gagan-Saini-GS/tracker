import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

/// Configuration class that reads data from app_config.json
/// and provides global access to configuration variables
class Config {
  static Map<String, dynamic>? _config;
  static bool _isInitialized = false;

  /// Initialize the configuration by reading from app_config.json
  /// This should be called once during app startup
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Read the JSON file from assets
      final String jsonString = await rootBundle.loadString(
        'assets/config/app_config.json',
      );
      _config = json.decode(jsonString) as Map<String, dynamic>;
      _isInitialized = true;
    } catch (e) {
      // If reading from assets fails, try to read from file system (for development)
      try {
        final File configFile = File('assets/config/app_config.json');
        if (await configFile.exists()) {
          final String jsonString = await configFile.readAsString();
          _config = json.decode(jsonString) as Map<String, dynamic>;
          _isInitialized = true;
        } else {
          throw Exception('Config file not found');
        }
      } catch (fileError) {
        throw Exception(
          'Failed to load configuration: $e, File error: $fileError',
        );
      }
    }
  }

  /// Get a configuration value by key
  /// Returns null if the key doesn't exist or config isn't initialized
  static dynamic get(String key) {
    if (!_isInitialized) {
      throw Exception(
        'Config not initialized. Call Config.initialize() first.',
      );
    }
    return _config?[key];
  }

  /// Get a configuration value as String
  /// Returns null if the key doesn't exist or value is not a string
  static String? getString(String key) {
    final value = get(key);
    return value is String ? value : null;
  }

  /// Get a configuration value as int
  /// Returns null if the key doesn't exist or value is not an int
  static int? getInt(String key) {
    final value = get(key);
    return value is int ? value : null;
  }

  /// Get a configuration value as double
  /// Returns null if the key doesn't exist or value is not a double
  static double? getDouble(String key) {
    final value = get(key);
    return value is double ? value : null;
  }

  /// Get a configuration value as bool
  /// Returns null if the key doesn't exist or value is not a bool
  static bool? getBool(String key) {
    final value = get(key);
    return value is bool ? value : null;
  }

  /// Get a configuration value as Map
  /// Returns null if the key doesn't exist or value is not a Map
  static Map<String, dynamic>? getMap(String key) {
    final value = get(key);
    return value is Map<String, dynamic> ? value : null;
  }

  /// Get a configuration value as List
  /// Returns null if the key doesn't exist or value is not a List
  static List<dynamic>? getList(String key) {
    final value = get(key);
    return value is List<dynamic> ? value : null;
  }

  /// Check if configuration is initialized
  static bool get isInitialized => _isInitialized;

  /// Get all configuration data
  static Map<String, dynamic>? get all =>
      _isInitialized ? Map.unmodifiable(_config!) : null;
}

// Global configuration variables for easy access
class AppConfig {
  /// Server base URL from configuration
  static String get serverBaseUrl => Config.getString('SERVER_BASE_URL') ?? '';

  // Add more configuration getters as needed
  // Example:
  // static String get apiVersion => Config.getString('API_VERSION') ?? 'v1';
  // static int get timeoutSeconds => Config.getInt('TIMEOUT_SECONDS') ?? 30;
  // static bool get debugMode => Config.getBool('DEBUG_MODE') ?? false;
}
