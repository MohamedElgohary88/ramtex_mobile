import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

/// Global GetIt instance for dependency injection
final GetIt getIt = GetIt.instance;

/// Shorthand for accessing GetIt instance
final sl = getIt;

/// Initialize all dependencies
/// 
/// Call this before runApp() in main.dart
Future<void> initializeDependencies() async {
  // ============================================
  // CORE SERVICES
  // ============================================

  // Secure Storage Service (Singleton)
  getIt.registerSingleton<SecureStorageService>(
    SecureStorageService.instance,
  );

  // API Client (Singleton) - Initialize after storage service
  final apiClient = ApiClient.instance;
  apiClient.init(
    storageService: getIt<SecureStorageService>(),
  );
  getIt.registerSingleton<ApiClient>(apiClient);

  // ============================================
  // AUTH FEATURE
  // ============================================

  // Auth DataSource
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      storageService: getIt<SecureStorageService>(),
    ),
  );

  // Auth Cubit (Factory - new instance per screen)
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(authRepository: getIt<AuthRepository>()),
  );
}

/// Reset all dependencies (useful for testing or logout)
Future<void> resetDependencies() async {
  await getIt.reset();
}
