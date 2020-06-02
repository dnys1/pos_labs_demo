part of 'login_bloc.dart';

/// Represents an Exception thrown during the login process.
class LoginException extends Equatable implements Exception {
  /// The platform code, if any (given by some packages like Firebase Auth)
  final String code;
  /// The message describing the exception.
  final String message;

  LoginException({
    this.code,
    @required this.message,
  });

  factory LoginException.unknown() => LoginException(
    message: 'An unknown error occurred. Please try again.',
  );

  @override
  String toString() {
    return 'LoginException { code: $code, message: $message }';
  }

  @override
  List<Object> get props => [code, message];
}