import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _key = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _key);
  }

  Future<void> deleteToken() async {
    debugPrint("Deleting token");
    await _storage.delete(key: _key);
  }
}
