import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';

/// API Client - Singleton Dio wrapper for all network requests.
///
/// Features:
/// - Pre-configured with base URL, headers, and timeouts
/// - AuthInterceptor for automatic Bearer token injection
/// - Logging interceptor for debugging (debug builds only)
/// - Consistent error handling with custom exceptions
class ApiClient {
  ApiClient._internal();

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  static ApiClient get instance => _instance;

  late final Dio _dio;
  bool _isInitialized = false;

  /// Initialize the API client with dependencies
  void init({SecureStorageService? storageService, String? baseUrl}) {
    if (_isInitialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Add Auth Interceptor
    _dio.interceptors.add(AuthInterceptor(storageService: storageService));

    // Add Logging Interceptor (debug only)
    assert(() {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (log) => debugPrint('🌐 API: $log'),
        ),
      );
      return true;
    }());

    _isInitialized = true;
  }

  /// Get the Dio instance (for direct access if needed)
  Dio get dio {
    if (!_isInitialized) {
      throw StateError(
        'ApiClient not initialized. Call ApiClient.instance.init() first.',
      );
    }
    return _dio;
  }

  // ============================================
  // HTTP METHODS
  // ============================================

  /// Perform GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Perform POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Perform PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Perform DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ============================================
  // ERROR HANDLING
  // ============================================

  /// Convert DioException to custom AppException
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const UnknownException(message: 'Request was cancelled.');

      default:
        return UnknownException(
          message: error.message ?? 'An unexpected error occurred.',
        );
    }
  }

  /// Handle HTTP response errors based on status code
  AppException _handleResponseError(Response? response) {
    if (response == null) {
      return const ServerException();
    }

    final statusCode = response.statusCode ?? 500;
    final data = response.data;

    // Extract message from response
    String message = 'An error occurred.';
    Map<String, List<String>>? errors;

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;

      if (data['errors'] is Map) {
        errors = (data['errors'] as Map).map(
          (key, value) => MapEntry(
            key.toString(),
            (value as List).map((e) => e.toString()).toList(),
          ),
        );
      }
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(message: message, statusCode: statusCode);
      case 401:
        return UnauthorizedException(message: message, statusCode: statusCode);
      case 404:
        return NotFoundException(message: message, statusCode: statusCode);
      case 422:
        return ValidationException(
          message: message,
          statusCode: statusCode,
          errors: errors,
        );
      case >= 500:
        return ServerException(message: message, statusCode: statusCode);
      default:
        return UnknownException(message: message, statusCode: statusCode);
    }
  }
}
