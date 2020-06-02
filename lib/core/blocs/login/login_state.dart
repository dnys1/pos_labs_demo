part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final BiometricType biometricType;

  const LoginInitial({@required this.biometricType});

  @override
  List<Object> get props => [biometricType];

  @override
  String toString() {
    return 'LoginInitial { biometricType: $biometricType }';
  }
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final LoginException exception;

  const LoginFailure({@required this.exception});

  factory LoginFailure.unknown() => LoginFailure(
    exception: LoginException.unknown(),
  );

  @override
  List<Object> get props => [exception];

  @override
  String toString() {
    return 'LoginException { exception: $exception }';
  }
}
