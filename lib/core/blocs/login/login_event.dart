part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// Loads the login configuration upon app loading.
class AppLoaded extends LoginEvent {}

/// Initiates a new login request.
class LoginInitiated extends LoginEvent {
  final LoginMethod method;

  const LoginInitiated({@required this.method});

  @override
  List<Object> get props => [method];

  @override
  String toString() {
    return 'LoginInitiated { method: $method }';
  }
}

/// Clears the current login request.
class LoginCleared extends LoginEvent {}