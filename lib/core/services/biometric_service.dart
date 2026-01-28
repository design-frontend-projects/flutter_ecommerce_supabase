import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

/// Biometric authentication service
class BiometricService extends GetxService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports biometrics
  Future<bool> get canCheckBiometrics async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  /// Check if device has biometrics enrolled
  Future<bool> get isDeviceSupported async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> get availableBiometrics async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Check if authentication is possible
  Future<bool> canAuthenticate() async {
    final canCheck = await canCheckBiometrics;
    final deviceSupported = await isDeviceSupported;
    return canCheck && deviceSupported;
  }

  /// Authenticate with biometrics
  Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
    bool biometricOnly = false,
  }) async {
    try {
      final canAuth = await canCheckBiometrics && await isDeviceSupported;
      if (!canAuth) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: biometricOnly,
        ),
      );
    } on PlatformException catch (e) {
      throw BiometricException(e.message ?? 'Authentication failed');
    }
  }

  /// Cancel authentication
  Future<bool> cancelAuthentication() async {
    try {
      return await _auth.stopAuthentication();
    } on PlatformException {
      return false;
    }
  }
}

/// Custom exception for biometric errors
class BiometricException implements Exception {
  final String message;

  BiometricException(this.message);

  @override
  String toString() => 'BiometricException: $message';
}
