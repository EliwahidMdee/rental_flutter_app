import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Service
/// 
/// Manages secure storage for sensitive data like tokens

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  
  // Keys
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _biometricKey = 'biometric_enabled';
  
  /// Save auth token
  static Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: _authTokenKey, value: token);
    } catch (e) {
      throw Exception('Failed to save auth token: $e');
    }
  }
  
  /// Get auth token
  static Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: _authTokenKey);
    } catch (e) {
      throw Exception('Failed to read auth token: $e');
    }
  }
  
  /// Delete auth token
  static Future<void> deleteAuthToken() async {
    try {
      await _storage.delete(key: _authTokenKey);
    } catch (e) {
      throw Exception('Failed to delete auth token: $e');
    }
  }
  
  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      throw Exception('Failed to save refresh token: $e');
    }
  }
  
  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      throw Exception('Failed to read refresh token: $e');
    }
  }
  
  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
    } catch (e) {
      throw Exception('Failed to save user ID: $e');
    }
  }
  
  /// Get user ID
  static Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      throw Exception('Failed to read user ID: $e');
    }
  }
  
  /// Check if biometric is enabled
  static Future<bool> isBiometricEnabled() async {
    try {
      final value = await _storage.read(key: _biometricKey);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }
  
  /// Set biometric enabled
  static Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _storage.write(
        key: _biometricKey,
        value: enabled ? 'true' : 'false',
      );
    } catch (e) {
      throw Exception('Failed to set biometric preference: $e');
    }
  }
  
  /// Write custom value
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw Exception('Failed to write to secure storage: $e');
    }
  }
  
  /// Read custom value
  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw Exception('Failed to read from secure storage: $e');
    }
  }
  
  /// Delete custom value
  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw Exception('Failed to delete from secure storage: $e');
    }
  }
  
  /// Clear all data
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear secure storage: $e');
    }
  }
}
