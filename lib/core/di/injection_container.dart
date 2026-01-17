import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/home.dart';
import '../../features/products/products.dart';
import '../../features/favorites/favorites.dart';
import '../../features/cart/cart.dart';
import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';

import 'package:ramtex_mobile/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:ramtex_mobile/features/orders/data/repositories/order_repository_impl.dart';
import 'package:ramtex_mobile/features/orders/domain/repositories/order_repository.dart';
import 'package:ramtex_mobile/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:ramtex_mobile/features/orders/presentation/cubit/order_details_cubit.dart';

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

  // Features - Products
  getIt.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      remoteDataSource: getIt<ProductsRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<ProductListCubit>(
    () => ProductListCubit(repository: getIt<ProductsRepository>()),
  );
  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(
      productsRepository: getIt<ProductsRepository>(),
      cartRepository: getIt<CartRepository>(),
    ),
  );

  // Features - Favorites
  getIt.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      remoteDataSource: getIt<FavoritesRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(repository: getIt<FavoritesRepository>()),
  );

  // Features - Cart
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: getIt<CartRemoteDataSource>()),
  );
  getIt.registerFactory<CartCubit>(
    () => CartCubit(
      repository: getIt<CartRepository>(),
      orderRepository: getIt<OrderRepository>(),
    ),
  );

  // Features - Orders
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: getIt<OrderRemoteDataSource>()),
  );
  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(repository: getIt<OrderRepository>()),
  );
  getIt.registerFactory<OrderDetailsCubit>(
    () => OrderDetailsCubit(repository: getIt<OrderRepository>()),
  );
}

/// Reset all dependencies (useful for testing or logout)
Future<void> resetDependencies() async {
  await getIt.reset();
}
