import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../services/auth_service.dart';
import '../../enums/biometric_type.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_method.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthService _auth;

  LoginBloc({@required AuthService auth}) {
    assert(auth != null, 'AuthService must be provided');
    _auth = auth;
  }

  @override
  LoginState get initialState => LoginLoading();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginStarted) {
      yield LoginInitial(
        biometricType: await _auth.availableBiometricType,
      );
    } else if (event is LoginInitiated) {
      yield* _mapLoginInitiatedToState(method: event.method);
    } else if (event is LoginCleared) {
      yield LoginInitial(
        biometricType: await _auth.availableBiometricType,
      );
    }
  }

  /// Login the user using [AuthenticationService]
  Stream<LoginState> _mapLoginInitiatedToState({LoginMethod method}) async* {
    yield LoginLoading();

    try {
      bool didLoginSuccessfully;
      switch (method) {
        case LoginMethod.Facebook:
          didLoginSuccessfully = await _auth.initiateFacebookLogin();
          break;
        case LoginMethod.Local:
          didLoginSuccessfully = await _auth.initiateBiometricLogin();
          break;
      }

      if (didLoginSuccessfully) {
        yield LoginSuccess();
      } else {
        // Direct users to login screen if unsuccessful
        yield LoginInitial(biometricType: await _auth.availableBiometricType);
      }
    } on PlatformException catch (e) {
      yield LoginFailure(
        exception: LoginException(
          message: e.message,
          code: e.code,
        ),
      );
    } on LoginException catch (e) {
      yield LoginFailure(exception: e);
    } catch (e) {
      yield LoginFailure.unknown();
    }
  }
}
