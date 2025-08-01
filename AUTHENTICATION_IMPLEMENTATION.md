# Authentication Implementation Guide

This document explains the authentication implementation including Refresh Token and Logout functionality based on the API documentation.

## Overview

The authentication system has been enhanced to support:

1. **Refresh Token Management** - Automatic token refresh when API calls fail
2. **Logout Functionality** - Proper logout with API call and token cleanup
3. **Token Interceptor** - Automatic token refresh for authenticated API calls

## Key Components

### 1. AuthTokenStorage (`lib/storage/auth_token_storage.dart`)

Enhanced to handle both access tokens and refresh tokens:

- `saveToken()` - Save access token
- `getToken()` - Retrieve access token
- `saveRefreshToken()` - Save refresh token
- `getRefreshToken()` - Retrieve refresh token
- `clearAllTokens()` - Clear both tokens (for logout)

### 2. Refresh Token Provider (`lib/providers/refresh_token_provider.dart`)

Manages token refresh logic:

- `refreshToken()` - Attempts to refresh the access token using refresh token
- State management for refresh status and errors

### 3. Logout Provider (`lib/providers/logout_provider.dart`)

Handles logout functionality:

- `logout()` - Calls logout API and clears all tokens
- State management for logout status and errors

### 4. Token Interceptor (`lib/api/token_interceptor.dart`)

Automatically handles token refresh for API calls:

- `makeAuthenticatedRequest()` - Makes API calls with automatic token refresh
- Handles 401 errors by attempting token refresh and retrying the request

### 5. Transaction API Provider (`lib/providers/transaction_api_provider.dart`)

Example of using the token interceptor for authenticated API calls:

- `fetchRecentTransactions()` - Get recent transactions
- `fetchTransactionHistory()` - Get transaction history
- `addTransaction()` - Add new transaction
- `deleteTransaction()` - Delete transaction

## Usage Examples

### Login (Updated)

```dart
// Login now saves both access and refresh tokens
final response = await api.post('auth/login', {
  'email': email,
  'password': password,
});

final accessToken = response['data']['accessToken'];
final refreshToken = response['data']['refreshToken'];

await authTokenStorage.saveToken(accessToken);
await authTokenStorage.saveRefreshToken(refreshToken);
```

### Manual Token Refresh

```dart
import 'package:tracker/providers/refresh_token_provider.dart';

final refreshNotifier = ref.read(refreshTokenProvider.notifier);
final success = await refreshNotifier.refreshToken();
```

### Logout

```dart
import 'package:tracker/providers/logout_provider.dart';

final logoutNotifier = ref.read(logoutProvider.notifier);
await logoutNotifier.logout(context);
```

### Authenticated API Calls with Auto-Refresh

```dart
import 'package:tracker/providers/token_interceptor_provider.dart';

final tokenInterceptor = ref.read(tokenInterceptorProvider);

// This will automatically handle token refresh if needed
final response = await tokenInterceptor.makeAuthenticatedRequest(
  'transactions/recent',
  'GET',
);
```

### Using Transaction API Provider

```dart
import 'package:tracker/providers/transaction_api_provider.dart';

final transactionNotifier = ref.read(transactionApiProvider.notifier);

// Fetch transactions (handles auth automatically)
await transactionNotifier.fetchRecentTransactions();

// Add transaction
await transactionNotifier.addTransaction(
  title: 'Coffee',
  type: 'Expense',
  amount: 5.0,
  date: '2025-01-27',
  note: 'Morning coffee',
);
```

## API Endpoints Implemented

### Auth Endpoints

- ✅ **POST** `/auth/signup` - User registration
- ✅ **POST** `/auth/login` - User login (saves both tokens)
- ✅ **POST** `/auth/refresh` - Refresh access token
- ✅ **POST** `/auth/logout` - User logout

### Transaction Endpoints (with auto-refresh)

- ✅ **GET** `/transactions/recent` - Get recent transactions
- ✅ **GET** `/transactions/history` - Get transaction history
- ✅ **POST** `/transactions/add` - Add new transaction
- ✅ **DELETE** `/transactions/:id` - Delete transaction

## Error Handling

### Token Refresh Errors

- If refresh token is missing or invalid, user is redirected to login
- Refresh attempts are debounced to prevent multiple simultaneous requests
- Errors are logged and can be handled gracefully

### Logout Errors

- Even if logout API call fails, local tokens are cleared
- User is redirected to onboarding screen regardless of API success/failure
- Error messages are displayed via SnackBar

### API Call Errors

- 401 errors trigger automatic token refresh
- If refresh fails, user is redirected to login
- Other errors are handled by individual providers

## Security Features

1. **Secure Storage** - Tokens are stored using `flutter_secure_storage`
2. **Automatic Refresh** - Tokens are refreshed automatically when needed
3. **Proper Cleanup** - All tokens are cleared on logout
4. **Error Handling** - Graceful handling of token expiration and API failures

## Integration Points

### Profile Screen

The profile screen now uses the logout provider for proper logout functionality with loading states and error handling.

### Transaction Management

Transaction API calls now use the token interceptor for automatic authentication and token refresh.

### App Initialization

You can use `TokenUtils.validateAndRefreshTokenIfNeeded()` during app startup to validate existing tokens.

## Testing

To test the implementation:

1. **Login** - Verify both tokens are saved
2. **API Calls** - Make authenticated API calls
3. **Token Expiration** - Wait for token to expire or manually trigger 401
4. **Auto Refresh** - Verify token is automatically refreshed
5. **Logout** - Verify all tokens are cleared and user is redirected

## Future Enhancements

1. **JWT Decoding** - Add JWT token validation and expiration checking
2. **Biometric Auth** - Add biometric authentication support
3. **Offline Support** - Cache data for offline usage
4. **Session Management** - Add session timeout and auto-logout
