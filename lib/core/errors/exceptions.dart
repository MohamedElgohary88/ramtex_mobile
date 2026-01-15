/// Custom exception classes for error handling.
/// 
/// These exceptions are thrown from data layer and converted to Failures
/// in the repository layer for proper error handling.
library;

/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'AppException: $message (statusCode: $statusCode)';
}

/// Exception thrown when server returns error (5xx status codes)
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred. Please try again later.',
    super.statusCode = 500,
    super.data,
  });
}

/// Exception thrown when authentication fails (401 status code)
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized. Please login again.',
    super.statusCode = 401,
    super.data,
  });
}

/// Exception thrown for validation errors (422 status code)
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation failed.',
    super.statusCode = 422,
    super.data,
    this.errors,
  });

  /// Get first error message from errors map
  String? get firstError {
    if (errors == null || errors!.isEmpty) return message;
    final firstKey = errors!.keys.first;
    final firstErrors = errors![firstKey];
    return firstErrors?.isNotEmpty == true ? firstErrors!.first : message;
  }
}

/// Exception thrown when resource is not found (404 status code)
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
    super.data,
  });
}

/// Exception thrown for bad requests (400 status code)
class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Bad request.',
    super.statusCode = 400,
    super.data,
  });
}

/// Exception thrown when network connection fails
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
    super.data,
  });
}

/// Exception thrown for cache/storage errors
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred.',
    super.statusCode,
    super.data,
  });
}

/// Exception thrown when request times out
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
    super.data,
  });
}

/// Exception thrown for unknown/unexpected errors
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred.',
    super.statusCode,
    super.data,
  });
}
