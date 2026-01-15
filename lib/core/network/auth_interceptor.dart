import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

/// Auth Interceptor for Dio that handles Bearer token injection.
/// 
/// This interceptor:
/// - Reads the JWT token from SecureStorageService
/// - Adds Authorization header to all requests if token exists
/// - Handles 401 responses by clearing token (triggering re-login)
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;

  AuthInterceptor({
    SecureStorageService? storageService,
  }) : _storageService = storageService ?? SecureStorageService.instance;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for login/register endpoints
    final noAuthPaths = ['/client/login', '/client/register', '/ping'];
    final needsAuth = !noAuthPaths.any((path) => options.path.endsWith(path));

    if (needsAuth) {
      final token = await _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - clear token and let app handle redirect
    if (err.response?.statusCode == 401) {
      await _storageService.clearAll();
      // The app should listen for auth state changes and redirect to login
    }

    handler.next(err);
  }
}
