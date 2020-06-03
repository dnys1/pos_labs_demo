import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents an Exception thrown in this app.
///
/// Used instead of dart's [Exception] for custom behavior and extensions.
abstract class BaseException extends Equatable implements Exception {
  /// The platform code, if any (given by some packages like Google Maps)
  final String code;

  /// The message describing the exception.
  final String message;

  const BaseException({
    this.code,
    @required this.message,
  });

  @override
  String toString() {
    return '$runtimeType { code: $code, message: $message }';
  }

  @override
  List<Object> get props => [code, message];
}
