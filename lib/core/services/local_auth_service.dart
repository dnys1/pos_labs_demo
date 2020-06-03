import 'package:local_auth/local_auth.dart' as local_auth;
import 'package:logging/logging.dart';

import '../enums/biometric_type.dart';

/// Service for handling local authentication (Face ID, Touch ID)
class LocalAuthService {
  static final Logger _logger = Logger('LocalAuthService');
  static final _auth = local_auth.LocalAuthentication();

  /// Returns the available biometric login type (Face ID, Touch ID, or None)
  Future<BiometricType> getAvailableBiometric() async {
    _logger.finer('getAvailableBiometric');
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    _logger.finer('getAvailableBiometric: canCheckBiometrics $canCheckBiometrics');

    if (!canCheckBiometrics) {
      return BiometricType.None;
    }

    List<local_auth.BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();

    _logger.finer('getAvailableBiometric: availableBiometrics $availableBiometrics');

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
    _logger.finer('initiateBiometricLogin');
    return _auth.authenticateWithBiometrics(
        localizedReason: 'Please authenticate to login');
  }
}
