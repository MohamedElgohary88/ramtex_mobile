import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/di/injection_container.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';

/// App Router Configuration using GoRouter
/// 
/// Declarative routing with:
/// - Named routes for type-safe navigation
/// - Auth-based redirects
/// - Shell routes for bottom navigation (future)
class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();
  factory AppRouter() => _instance;
  static AppRouter get instance => _instance;

  // ============================================
  // ROUTE NAMES
  // ============================================
  
  static const String splash = 'splash';
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

  // ============================================
  // ROUTER CONFIGURATION
  // ============================================

  late final GoRouter router = GoRouter(
    initialLocation: loginPath, // Start at login for now
    debugLogDiagnostics: true,
    routes: [
      // Splash / Initial Route
      GoRoute(
        path: splashPath,
        name: splash,
        builder: (context, state) => const _PlaceholderScreen(title: 'Splash'),
      ),
      
      // Auth Routes
      GoRoute(
        path: loginPath,
        name: login,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: registerPath,
        name: register,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      
      // Main App Routes
      GoRoute(
        path: homePath,
        name: home,
        builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
      ),
      
      // Products
      GoRoute(
        path: productsPath,
        name: products,
        builder: (context, state) => const _PlaceholderScreen(title: 'Products'),
      ),
      GoRoute(
        path: productDetailsPath,
        name: productDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _PlaceholderScreen(title: 'Product: $id');
        },
      ),
      
      // Cart & Checkout
      GoRoute(
        path: cartPath,
        name: cart,
        builder: (context, state) => const _PlaceholderScreen(title: 'Cart'),
      ),
      GoRoute(
        path: checkoutPath,
        name: checkout,
        builder: (context, state) => const _PlaceholderScreen(title: 'Checkout'),
      ),
      
      // Orders
      GoRoute(
        path: ordersPath,
        name: orders,
        builder: (context, state) => const _PlaceholderScreen(title: 'Orders'),
      ),
      GoRoute(
        path: orderDetailsPath,
        name: orderDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _PlaceholderScreen(title: 'Order: $id');
        },
      ),
      
      // Profile & Favorites
      GoRoute(
        path: profilePath,
        name: profile,
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
      GoRoute(
        path: favoritesPath,
        name: favorites,
        builder: (context, state) => const _PlaceholderScreen(title: 'Favorites'),
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
