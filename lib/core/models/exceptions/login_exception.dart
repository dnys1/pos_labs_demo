import 'package:meta/meta.dart';

import 'base_exception.dart';

/// Represents an Exception thrown during the login process.
class LoginException extends BaseException {
  LoginException({
    String code,
    @required String message,
  }) : super(message: message, code: code);

  factory LoginException.unknown() => LoginException(
        message: 'An unknown error occurred. Please try again.',
      );
}
