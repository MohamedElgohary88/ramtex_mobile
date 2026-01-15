import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';
import '../../features/auth/auth.dart';
import '../../features/home/home.dart';

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

  // Features - Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      storageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(authRepository: getIt<AuthRepository>()),
  );

  // Features - Home
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: getIt<HomeRemoteDataSource>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(homeRepository: getIt<HomeRepository>()),
  );
}

/// Reset all dependencies (useful for testing or logout)
Future<void> resetDependencies() async {
  await getIt.reset();
}
