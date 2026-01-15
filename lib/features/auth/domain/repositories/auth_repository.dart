import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../params/auth_params.dart';

/// Result type for auth operations
/// Using a simple sealed class pattern instead of dartz Either
sealed class AuthResult<T> {
  const AuthResult();
}

class AuthSuccessResult<T> extends AuthResult<T> {
  final T data;
  const AuthSuccessResult(this.data);
}

class AuthFailureResult<T> extends AuthResult<T> {
  final Failure failure;
  const AuthFailureResult(this.failure);
}

/// Auth Repository Interface (Domain Layer)
///
/// Defines the contract for authentication operations.
/// Implementation lives in the data layer.
abstract class AuthRepository {
  /// Login with email/phone and password
  /// Returns [UserEntity] on success or [Failure] on error
  Future<AuthResult<UserEntity>> login(LoginParams params);

  /// Register a new user
  /// Returns [UserEntity] on success or [Failure] on error
  Future<AuthResult<UserEntity>> register(RegisterParams params);

  /// Logout current user
  /// Returns true on success or [Failure] on error
  Future<AuthResult<bool>> logout();

  /// Get current authenticated user
  /// Returns null if not authenticated
  Future<UserEntity?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
