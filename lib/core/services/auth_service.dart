import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../enums/biometric_type.dart';
import 'local_auth_service.dart';

/// Service for handling authentication requests with server and local authentication.
class AuthService {
  static final Logger _logger = Logger('AuthService');
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FacebookLogin _facebookLogin = FacebookLogin();

  LocalAuthService _localAuth;

  AuthService({@required LocalAuthService localAuth}) {
    assert(localAuth != null, 'LocalAuthService must be provided');
    _localAuth = localAuth;
  }

  /// Cache the available biometric type
  BiometricType _availableBiometricType;
  
  /// The available biometric type for the current device
  Future<BiometricType> get availableBiometricType async {
    // Calling `getAvailableBiometric` is not supported on all versions of Android.
    // Full support of an adaptive UI based off the value of this call on Android would require
    // more information about the platform and device.
    if (_availableBiometricType == null) {
      try {
        _availableBiometricType = await _localAuth.getAvailableBiometric();
      } catch (e) {
        _availableBiometricType = BiometricType.None;
      }
    }
    _logger.finer('availableBiometricType: Available biometric type ($_availableBiometricType)');
    return _availableBiometricType;
  }

  /// Login using local authentication (Face ID/Touch ID)
  Future<bool> initiateBiometricLogin() async {
    _logger.finer('initiateBiometricLogin');
    return _localAuth.initiateBiometricLogin();
  }

  /// Login using Facebook OAuth login
  Future<bool> initiateFacebookLogin() async {
    // Login using Facebook webview
    final loginResult = await _facebookLogin.logIn(['email']);
    _logger.finer('initiateFacebookLogin: loginResult', loginResult);
    _logger.finer('initiateFacebookLogin: status ${loginResult.status}');

    switch (loginResult.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: loginResult.accessToken.token,
        );
        await _auth.signInWithCredential(credential);
        return true;
      case FacebookLoginStatus.cancelledByUser:
        return false;
      case FacebookLoginStatus.error:
        throw Exception(loginResult.errorMessage);
    }

    return false;
  }
}
