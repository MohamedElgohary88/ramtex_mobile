import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Auth State for AuthCubit
/// 
/// Represents the different states of authentication.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - checking authentication status
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state - API call in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state - user is logged in
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state - user is not logged in
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state - auth operation failed
class AuthError extends AuthState {
  final String message;
  final Map<String, List<String>>? fieldErrors;

  const AuthError({
    required this.message,
    this.fieldErrors,
  });

  /// Get error for a specific field (for inline validation display)
  String? getFieldError(String field) {
    if (fieldErrors == null) return null;
    final errors = fieldErrors![field];
    return errors?.isNotEmpty == true ? errors!.first : null;
  }

  @override
  List<Object?> get props => [message, fieldErrors];
}
