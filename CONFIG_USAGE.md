# Configuration Management

This document explains how to use the `Config` class and `app_config.json` file for managing application configuration.

## Overview

The `Config` class provides a centralized way to manage application configuration by reading from a JSON file (`app_config.json`) and exposing the values as global variables for use throughout the application.

## File Structure

```
assets/
  config/
    app_config.json          # Configuration file
lib/
  utils/
    config.dart              # Config class implementation
```

## Configuration File (app_config.json)

The `app_config.json` file should be placed in `assets/config/` and contains key-value pairs for your application configuration.

### Example Configuration

```json
{
  "SERVER_BASE_URL": "https://artha-backend-two.vercel.app/",
  "API_VERSION": "v1",
  "TIMEOUT_SECONDS": 30,
  "DEBUG_MODE": false,
  "FEATURE_FLAGS": {
    "ENABLE_NOTIFICATIONS": true,
    "ENABLE_ANALYTICS": false
  }
}
```

## Usage

### 1. Initialization

The configuration must be initialized before use. This is typically done in `main.dart`:

```dart
import 'package:tracker/utils/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize configuration
  await Config.initialize();

  runApp(ProviderScope(child: MyApp()));
}
```

### 2. Using the Config Class

#### Basic Usage

```dart
import 'package:tracker/utils/config.dart';

// Get a configuration value
String? serverUrl = Config.getString('SERVER_BASE_URL');
int? timeout = Config.getInt('TIMEOUT_SECONDS');
bool? debugMode = Config.getBool('DEBUG_MODE');
```

#### Using AppConfig (Recommended)

For commonly used configuration values, use the `AppConfig` class:

```dart
import 'package:tracker/utils/config.dart';

// Get server base URL
String serverUrl = AppConfig.serverBaseUrl;
```

### 3. Available Methods

The `Config` class provides several methods for accessing configuration values:

- `Config.get(key)` - Get any value
- `Config.getString(key)` - Get string value
- `Config.getInt(key)` - Get integer value
- `Config.getDouble(key)` - Get double value
- `Config.getBool(key)` - Get boolean value
- `Config.getMap(key)` - Get map value
- `Config.getList(key)` - Get list value

### 4. Error Handling

The Config class includes error handling:

```dart
try {
  String? serverUrl = Config.getString('SERVER_BASE_URL');
  if (serverUrl == null) {
    // Handle missing configuration
    print('Server URL not configured');
  }
} catch (e) {
  // Handle configuration not initialized
  print('Configuration not initialized: $e');
}
```

## Adding New Configuration Values

### 1. Update app_config.json

Add new key-value pairs to `assets/config/app_config.json`:

```json
{
  "SERVER_BASE_URL": "https://artha-backend-two.vercel.app/",
  "NEW_CONFIG_VALUE": "some value",
  "NEW_NUMBER_VALUE": 42,
  "NEW_BOOL_VALUE": true
}
```

### 2. Add to AppConfig Class

For commonly used values, add getters to the `AppConfig` class in `lib/utils/config.dart`:

```dart
class AppConfig {
  /// Server base URL from configuration
  static String get serverBaseUrl => Config.getString('SERVER_BASE_URL') ?? '';

  /// New configuration value
  static String get newConfigValue => Config.getString('NEW_CONFIG_VALUE') ?? '';

  /// New number value
  static int get newNumberValue => Config.getInt('NEW_NUMBER_VALUE') ?? 0;

  /// New boolean value
  static bool get newBoolValue => Config.getBool('NEW_BOOL_VALUE') ?? false;
}
```

## Best Practices

1. **Always initialize**: Call `Config.initialize()` in `main.dart` before using any configuration values.

2. **Use AppConfig for common values**: Add frequently used configuration values to the `AppConfig` class for easier access.

3. **Handle null values**: Always provide default values when using configuration values.

4. **Type safety**: Use the appropriate getter method (`getString`, `getInt`, etc.) for type safety.

5. **Error handling**: Wrap configuration access in try-catch blocks when appropriate.

## Example Usage in Providers

```dart
import 'package:tracker/utils/config.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authToken = ref.watch(authTokenProvider);
  return ApiService(baseUrl: AppConfig.serverBaseUrl, authToken: authToken);
});
```

## Troubleshooting

### Configuration Not Found

If you get a "Config file not found" error:

1. Ensure `app_config.json` exists in `assets/config/`
2. Verify the file is included in `pubspec.yaml` assets section
3. Check that the file path is correct

### Configuration Not Initialized

If you get a "Config not initialized" error:

1. Ensure `Config.initialize()` is called in `main.dart`
2. Make sure the initialization is awaited properly
3. Check that the initialization is called before any configuration access

### Asset Loading Issues

If assets are not loading:

1. Run `flutter clean` and `flutter pub get`
2. Restart the app
3. Check that the asset path in `pubspec.yaml` is correct
