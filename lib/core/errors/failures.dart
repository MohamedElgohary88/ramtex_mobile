import 'package:equatable/equatable.dart';

/// Abstract Failure class for handling errors in the domain layer.
/// 
/// Failures are returned from repositories and consumed by the presentation layer.
/// Using Equatable for value equality comparison in tests and state management.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure for server errors (5xx status codes)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred. Please try again later.',
    super.statusCode = 500,
  });
}

/// Failure for authentication errors (401)
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please login again.',
    super.statusCode = 401,
  });
}

/// Failure for validation errors (422)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    super.message = 'Validation failed.',
    super.statusCode = 422,
    this.errors,
  });

  /// Get first error message from errors map
  String get firstError {
    if (errors == null || errors!.isEmpty) return message;
    final firstKey = errors!.keys.first;
    final firstErrors = errors![firstKey];
    return firstErrors?.isNotEmpty == true ? firstErrors!.first : message;
  }

  @override
  List<Object?> get props => [message, statusCode, errors];
}

/// Failure for not found errors (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found.',
    super.statusCode = 404,
  });
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
  });
}

/// Failure for cache/storage errors
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred.',
    super.statusCode,
  });
}

/// Failure for request timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
  });
}

/// Generic unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.statusCode,
  });
}
