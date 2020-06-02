import 'package:local_auth/local_auth.dart' as local_auth;

import '../enums/biometric_type.dart';

/// Service for handling local authentication (Face ID, Touch ID)
class LocalAuthService {
  static final _auth = local_auth.LocalAuthentication();

  /// Returns the available biometric login type (Face ID, Touch ID, or None)
  Future<BiometricType> getAvailableBiometric() async {
    bool canCheckBiometrics = await _auth.canCheckBiometrics;

    if (!canCheckBiometrics) {
      return BiometricType.None;
    }

    List<local_auth.BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();

    if (availableBiometrics.contains(local_auth.BiometricType.face)) {
      return BiometricType.Face;
    } else if (availableBiometrics
        .contains(local_auth.BiometricType.fingerprint)) {
      return BiometricType.Touch;
    } else {
      return BiometricType.None;
    }
  }

  /// Login using the available biometric type (Face ID or Touch ID)
  Future<bool> initiateBiometricLogin() {
    return _auth.authenticateWithBiometrics(
        localizedReason: 'Please authenticate to login');
  }
}
