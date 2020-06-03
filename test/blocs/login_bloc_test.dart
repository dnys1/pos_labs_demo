import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pos_labs_demo/core/blocs/login/login_bloc.dart';
import 'package:pos_labs_demo/core/enums/biometric_type.dart';
import 'package:pos_labs_demo/core/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  MockAuthService _auth;
  
  setUp(() {
    _auth = MockAuthService();
    when(_auth.availableBiometricType)
      .thenAnswer((_) async => BiometricType.None);
  });

  group('LoginStarted', () {
    blocTest(
      '| Success',
      build: () async {
        return LoginBloc(auth: _auth);
      },
      act: (bloc) => bloc.add(LoginStarted()),
      expect: [LoginInitial(biometricType: BiometricType.None)],
    );
  });

  group('LoginInitiated', () {
    blocTest(
      '| Facebook - Success',
      build: () async {
        when(_auth.initiateFacebookLogin()).thenAnswer((_) async => true);
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Facebook));
      },
      expect: [
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginSuccess(),
      ],
    );

    blocTest(
      '| Facebook - Canceled',
      build: () async {
        when(_auth.initiateFacebookLogin()).thenAnswer((_) async => false);
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Facebook));
      },
      expect: [
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
      ],
    );

    blocTest(
      '| Facebook - Failure',
      build: () async {
        when(_auth.initiateFacebookLogin()).thenThrow(Exception());
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Facebook));
      },
      expect: [
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginFailure.unknown(),
      ],
    );

    blocTest(
      '| Local - Success',
      build: () async {
        when(_auth.initiateBiometricLogin()).thenAnswer((_) async => true);
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Local));
      },
      expect: [
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginSuccess(),
      ],
    );

    blocTest(
      '| Local - Canceled',
      build: () async {
        when(_auth.initiateBiometricLogin()).thenAnswer((_) async => false);
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Local));
      },
      expect: [
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
      ],
    );

    blocTest(
      '| Local - Failure',
      build: () async {
        when(_auth.initiateBiometricLogin()).thenThrow(Exception());
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Local));
      },
      expect: [
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginFailure.unknown(),
      ],
    );
  });
}
