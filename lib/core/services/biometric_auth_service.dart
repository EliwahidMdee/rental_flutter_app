import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

/// Biometric Auth Service
///
/// Handles fingerprint and face ID authentication
class BiometricAuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available
  static Future<bool> isAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  /// Check if device has biometric hardware
  static Future<bool> hasHardware() async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Authenticate with biometrics
  static Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
  }) async {
    try {
      // Check if biometric is available
      final isAvailable = await BiometricAuthService.isAvailable();
      if (!isAvailable) {
        return false;
      }

      // Attempt authentication
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      print('Biometric authentication error: ${e.message}');
      return false;
    }
  }

  /// Stop authentication
  static Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } on PlatformException {
      // Handle error
    }
  }

  /// Get biometric type string
  static String getBiometricTypeString(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (types.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (types.contains(BiometricType.iris)) {
      return 'Iris';
    } else if (types.contains(BiometricType.strong) || types.contains(BiometricType.weak)) {
      return 'Biometric';
    }
    return 'Biometric';
  }
}
