import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/params/auth_params.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Auth Cubit - Manages authentication state
///
/// Handles login, registration, logout, and session checking.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitial());

  /// Check if user is already authenticated (on app start)
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    final user = await _authRepository.getCurrentUser();

    if (user != null && user.isAuthenticated) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Login with email and password
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await _login(LoginParams.withEmail(email: email, password: password));
  }

  /// Login with phone and password
  Future<void> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    await _login(LoginParams.withPhone(phone: phone, password: password));
  }

  /// Internal login handler
  Future<void> _login(LoginParams params) async {
    emit(const AuthLoading());

    final result = await _authRepository.login(params);

    switch (result) {
      case AuthSuccessResult(data: final user):
        emit(AuthAuthenticated(user));
      case AuthFailureResult(failure: final failure):
        emit(_mapFailureToState(failure));
    }
  }

  /// Register a new user
  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    String? companyName,
    String? city,
    String? country,
  }) async {
    emit(const AuthLoading());

    final params = RegisterParams(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
      companyName: companyName,
      city: city,
      country: country,
    );

    final result = await _authRepository.register(params);

    switch (result) {
      case AuthSuccessResult(data: final user):
        emit(AuthAuthenticated(user));
      case AuthFailureResult(failure: final failure):
        emit(_mapFailureToState(failure));
    }
  }

  /// Logout current user
  Future<void> logout() async {
    emit(const AuthLoading());

    final result = await _authRepository.logout();

    switch (result) {
      case AuthSuccessResult():
        emit(const AuthUnauthenticated());
      case AuthFailureResult():
        // Even on error, consider user logged out locally
        emit(const AuthUnauthenticated());
    }
  }

  /// Map failure to error state
  AuthError _mapFailureToState(Failure failure) {
    if (failure is ValidationFailure) {
      return AuthError(message: failure.message, fieldErrors: failure.errors);
    }
    return AuthError(message: failure.message);
  }
}
