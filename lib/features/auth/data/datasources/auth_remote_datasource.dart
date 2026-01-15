import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/params/auth_params.dart';
import '../models/user_model.dart';

/// Auth Remote DataSource
/// 
/// Handles all authentication-related API calls.
/// Throws exceptions from ApiClient on errors.
abstract class AuthRemoteDataSource {
  /// Login with credentials
  Future<UserModel> login(LoginParams params);

  /// Register new user
  Future<UserModel> register(RegisterParams params);

  /// Logout current user
  Future<bool> logout();

  /// Get current user profile
  Future<UserModel> getCurrentUser();
}

/// Implementation of [AuthRemoteDataSource]
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<UserModel> login(LoginParams params) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: params.toJson(),
    );

    final data = response.data as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> register(RegisterParams params) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: params.toJson(),
    );

    final data = response.data as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  @override
  Future<bool> logout() async {
    await _apiClient.post(ApiConstants.logout);
    return true;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstants.me);

    final data = response.data as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}
