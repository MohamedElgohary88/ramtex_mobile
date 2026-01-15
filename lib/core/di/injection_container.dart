import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';

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
  // REPOSITORIES
  // ============================================
  // TODO: Register feature repositories here
  // Example:
  // getIt.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(apiClient: getIt<ApiClient>()),
  // );

  // ============================================
  // CUBITS / BLOCS
  // ============================================
  // TODO: Register feature cubits here
  // Example:
  // getIt.registerFactory<AuthCubit>(
  //   () => AuthCubit(authRepository: getIt<AuthRepository>()),
  // );
}

/// Reset all dependencies (useful for testing or logout)
Future<void> resetDependencies() async {
  await getIt.reset();
}
