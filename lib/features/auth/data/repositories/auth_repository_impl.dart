import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/params/auth_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Auth Repository Implementation
///
/// Implements [AuthRepository] interface from domain layer.
/// Handles error mapping and token persistence.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  // Cache the current user in memory
  UserModel? _cachedUser;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    SecureStorageService? storageService,
  }) : _remoteDataSource = remoteDataSource,
       _storageService = storageService ?? SecureStorageService.instance;

  @override
  Future<AuthResult<UserEntity>> login(LoginParams params) async {
    try {
      final user = await _remoteDataSource.login(params);

      // CRITICAL: Save token to secure storage
      await _storageService.saveToken(user.token);

      // Save client info
      await _storageService.saveClientInfo(
        clientId: user.id,
        name: user.name,
        email: user.email,
      );

      // Cache user
      _cachedUser = user;

      return AuthSuccessResult(user);
    } on AppException catch (e) {
      return AuthFailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return AuthFailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<AuthResult<UserEntity>> register(RegisterParams params) async {
    try {
      final user = await _remoteDataSource.register(params);

      // CRITICAL: Save token to secure storage
      await _storageService.saveToken(user.token);

      // Save client info
      await _storageService.saveClientInfo(
        clientId: user.id,
        name: user.name,
        email: user.email,
      );

      // Cache user
      _cachedUser = user;

      return AuthSuccessResult(user);
    } on AppException catch (e) {
      return AuthFailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return AuthFailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<AuthResult<bool>> logout() async {
    try {
      await _remoteDataSource.logout();

      // Clear all stored data
      await _storageService.clearAll();

      // Clear cache
      _cachedUser = null;

      return const AuthSuccessResult(true);
    } on AppException catch (e) {
      // Even if API fails, clear local data
      await _storageService.clearAll();
      _cachedUser = null;

      return AuthFailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      // Even if something fails, ensure we clear local data
      await _storageService.clearAll();
      _cachedUser = null;

      return AuthFailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // Return cached user if available
    if (_cachedUser != null) {
      return _cachedUser;
    }

    // Check if we have a token
    final hasToken = await _storageService.hasToken();
    if (!hasToken) {
      return null;
    }

    try {
      // Fetch from API
      final user = await _remoteDataSource.getCurrentUser();

      // Get token from storage and add to user
      final token = await _storageService.getToken();
      _cachedUser = user.copyWithToken(token ?? '');

      return _cachedUser;
    } catch (e) {
      // If fetch fails, return null (user needs to re-login)
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _storageService.hasToken();
  }

  /// Map exceptions to failures
  Failure _mapExceptionToFailure(AppException exception) {
    return switch (exception) {
      ServerException() => ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      ),
      UnauthorizedException() => AuthFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      ),
      ValidationException(errors: final errors) => ValidationFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        errors: errors,
      ),
      NotFoundException() => NotFoundFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      ),
      NetworkException() => const NetworkFailure(),
      TimeoutException() => const TimeoutFailure(),
      _ => UnknownFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      ),
    };
  }
}
