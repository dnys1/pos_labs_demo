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
      skip: 0,
      build: () async {
        return LoginBloc(auth: _auth);
      },
      act: (bloc) => bloc.add(LoginStarted()),
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
      ],
    );
  });

  group('LoginInitiated', () {
    blocTest(
      '| Facebook - Success',
      skip: 0,
      build: () async {
        when(_auth.initiateFacebookLogin()).thenAnswer((_) async => true);
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Facebook));
      },
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginSuccess(),
      ],
    );

    blocTest(
      '| Facebook - Canceled',
      skip: 0,
      build: () async {
        when(_auth.initiateFacebookLogin()).thenAnswer((_) async => false);
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Facebook));
      },
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
      ],
    );

    blocTest(
      '| Facebook - Failure',
      skip: 0,
      build: () async {
        when(_auth.initiateFacebookLogin()).thenThrow(Exception());
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Facebook));
      },
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginFailure.unknown(),
      ],
    );

    blocTest(
      '| Local - Success',
      skip: 0,
      build: () async {
        when(_auth.initiateBiometricLogin()).thenAnswer((_) async => true);
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Local));
      },
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginSuccess(),
      ],
    );

    blocTest(
      '| Local - Canceled',
      skip: 0,
      build: () async {
        when(_auth.initiateBiometricLogin()).thenAnswer((_) async => false);
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Local));
      },
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
      ],
    );

    blocTest(
      '| Local - Failure',
      skip: 0,
      build: () async {
        when(_auth.initiateBiometricLogin()).thenThrow(Exception());
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Local));
      },
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginFailure.unknown(),
      ],
    );
  });

  group('LoginCleared', () {
    blocTest(
      '| Facebook - Failure, then Cleared',
      skip: 0,
      build: () async {
        when(_auth.initiateFacebookLogin()).thenThrow(Exception());
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Facebook));
        bloc.add(LoginCleared());
      },
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginFailure.unknown(),
        LoginInitial(biometricType: BiometricType.None),
      ],
    );

    blocTest(
      '| Local - Failure, then Cleared',
      skip: 0,
      build: () async {
        when(_auth.initiateBiometricLogin()).thenThrow(Exception());
        return LoginBloc(auth: _auth);
      },
      act: (bloc) async {
        bloc.add(LoginStarted());
        bloc.add(LoginInitiated(method: LoginMethod.Local));
        bloc.add(LoginCleared());
      },
      expect: [
        LoginLoading(),
        LoginInitial(biometricType: BiometricType.None),
        LoginLoading(),
        LoginFailure.unknown(),
        LoginInitial(biometricType: BiometricType.None),
      ],
    );
  });
}
