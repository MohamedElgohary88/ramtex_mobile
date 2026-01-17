import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/di/injection_container.dart';
import '../core/router/go_router_refresh_stream.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/cubit/auth_state.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/products/domain/params/product_filter_params.dart';
import '../features/products/presentation/cubit/product_list_cubit.dart';
import '../features/products/presentation/cubit/product_details_cubit.dart';
import '../features/products/presentation/screens/search_screen.dart';
import '../features/products/presentation/screens/product_details_screen.dart';
import '../features/main/presentation/screens/main_screen.dart';
import '../features/cart/presentation/screens/cart_screen.dart';
import '../features/orders/presentation/screens/orders_screen.dart';
import '../features/orders/presentation/screens/order_details_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/account_info_screen.dart';
import '../features/profile/presentation/screens/about_us_screen.dart';
import '../features/profile/presentation/screens/privacy_policy_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';
import '../features/favorites/favorites.dart';
import '../features/profile/domain/entities/profile_entity.dart';

/// App Router Configuration using GoRouter
/// 
/// Declarative routing with:
/// - Named routes for type-safe navigation
/// - Auth-based redirects
/// - Shell routes for persistent bottom navigation
class AppRouter {
  final String initialLocation;

  AppRouter({required this.initialLocation});

  // ============================================
  // KEYS
  // ============================================

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  // ============================================
  // ROUTE NAMES
  // ============================================
  
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String products = 'products';
  static const String productDetails = 'productDetails';
  static const String cart = 'cart';
  static const String checkout = 'checkout';
  static const String orders = 'orders';
  static const String orderDetails = 'orderDetails';
  static const String profile = 'profile';
  static const String favorites = 'favorites';
  static const String accountInfo = 'accountInfo';
  static const String aboutUs = 'aboutUs';
  static const String privacyPolicy = 'privacyPolicy';
  static const String settings = 'settings';

  // ============================================
  // ROUTE PATHS
  // ============================================
  
  static const String splashPath = '/';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String homePath = '/home';
  static const String productsPath = '/products';
  static const String productDetailsPath = '/products/:id';
  static const String cartPath = '/cart';
  static const String checkoutPath = '/checkout';
  static const String ordersPath = '/orders';
  static const String orderDetailsPath = '/orders/:id';
  static const String profilePath = '/profile';
  static const String favoritesPath = '/favorites';
  static const String accountInfoPath = '/profile/info';
  static const String aboutUsPath = '/profile/about';
  static const String privacyPolicyPath = '/profile/privacy';
  static const String settingsPath = '/profile/settings';

  // ============================================
  // ROUTER CONFIGURATION
  // ============================================

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation, 
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(getIt<AuthCubit>().stream),
    redirect: (context, state) {
      final authState = getIt<AuthCubit>().state;
      final bool isAuthenticated = authState is AuthAuthenticated;
      // final bool isUnauthenticated = authState is AuthUnauthenticated; // Unused for now

      // Check location
      final bool isLoggingIn =
          state.matchedLocation == loginPath ||
          state.matchedLocation == registerPath;

      // Allow Loading to exist while initializing
      if (authState is AuthInitial || authState is AuthLoading) {
        return null;
      }

      // If unauthenticated, redirect to login unless already logging in
      if (!isAuthenticated && !isLoggingIn) {
        return loginPath;
      }

      // If authenticated, redirect login/register to home
      if (isAuthenticated && isLoggingIn) {
        return homePath;
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: loginPath,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerPath,
        name: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main App Shell (Botton Navigation)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Provide FavoritesCubit to the entire shell
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: homePath,
                name: home,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<HomeCubit>()..loadHomeData(),
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          
          // Branch 2: Cart
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: cartPath,
                name: cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          
          // Branch 3: Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ordersPath,
                name: orders,
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          
          // Branch 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                name: profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Standalone Routes (Push on top of Shell)
      GoRoute(
        path: productsPath,
        name: products,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<ProductListCubit>(),
          child: SearchScreen(
            initialFilters: state.extra as ProductFilterParams?,
          ),
        ),
      ),
      GoRoute(
        path: productDetailsPath,
        name: productDetails,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return BlocProvider(
            create: (_) => getIt<ProductDetailsCubit>(),
            child: ProductDetailsScreen(productId: id),
          );
        },
      ),
      GoRoute(
        path: favoritesPath,
        name: favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),

      // Unimplemented placeholders
      GoRoute(
        path: checkoutPath,
        name: checkout,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Checkout'),
      ),
      GoRoute(
        path: orderDetailsPath,
        name: orderDetails,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return OrderDetailsScreen(orderId: id);
        },
      ),
      
      // Profile Sub-routes
      GoRoute(
        path: accountInfoPath,
        name: accountInfo,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          // Expect ProfileEntity in extra for safety, or we could refetch if null
          // If null, we might need to handle it. For now assuming passed.
          final profile = state.extra as ProfileEntity?;
          if (profile == null) {
            // Fallback or error?
            // Maybe fetch? But that requires Cubit here.
            // Just show error or redirect back.
            // Let's assume it's passed.
            return const Scaffold(
              body: Center(child: Text('Error: No profile data passed')),
            );
          }
          return AccountInfoScreen(profile: profile);
        },
      ),
      GoRoute(
        path: aboutUsPath,
        name: aboutUs,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: privacyPolicyPath,
        name: privacyPolicy,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: settingsPath,
        name: settings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => _PlaceholderScreen(
      title: 'Error',
      message: state.error?.message ?? 'Page not found',
    ),
  );
}

/// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? message;

  const _PlaceholderScreen({
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
