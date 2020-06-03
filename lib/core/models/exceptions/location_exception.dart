import 'package:meta/meta.dart';

import 'base_exception.dart';

/// Represents an Exception thrown during the location retrieval process.
class LocationException extends BaseException {
  LocationException({
    String code,
    @required String message,
  }) : super(message: message, code: code);

  factory LocationException.unknown() => LocationException(
        message: 'An unknown error occurred. Please try again.',
      );
}
