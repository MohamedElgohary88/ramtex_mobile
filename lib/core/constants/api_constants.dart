/// API Constants for Ramtex Mobile App
/// 
/// Contains base URLs, endpoints, and other API-related constants.
library;

/// Environment configuration
enum ApiEnvironment {
  /// Android Emulator (uses 10.0.2.2 to access host)
  androidEmulator,

  /// iOS Simulator (uses localhost)
  iosSimulator,

  /// Physical Device via Ngrok tunnel
  physicalDevice,

  /// Production server
  production,
}

class ApiConstants {
  ApiConstants._();

  // ============================================
  // 🔧 CHANGE THIS TO SWITCH ENVIRONMENT
  // ============================================

  /// Current environment - CHANGE THIS for testing
  static const ApiEnvironment currentEnvironment =
      ApiEnvironment.physicalDevice;

  /// 📱 NGROK URL - Paste your ngrok URL here for physical device testing
  /// Example: 'https://abc123xyz.ngrok-free.app'
  static const String ngrokUrl = 'https://ce383dd7fa81.ngrok-free.app';

  // ============================================
  // BASE URL CONFIGURATION
  // ============================================
  
  /// Base URL for Android Emulator (uses 10.0.2.2 to access host machine)
  static const String baseUrlAndroid = 'http://10.0.2.2:8000/api';
  
  /// Base URL for iOS Simulator (uses localhost)
  static const String baseUrlIOS = 'http://localhost:8000/api';
  
  /// Base URL for Physical Device (via Ngrok)
  static String get baseUrlPhysicalDevice => '$ngrokUrl/api';
  
  /// Production base URL (update when deploying)
  static const String baseUrlProduction = 'https://api.ramtex.com/api';
  
  /// Current active base URL based on environment
  static String get baseUrl {
    switch (currentEnvironment) {
      case ApiEnvironment.androidEmulator:
        return baseUrlAndroid;
      case ApiEnvironment.iosSimulator:
        return baseUrlIOS;
      case ApiEnvironment.physicalDevice:
        return baseUrlPhysicalDevice;
      case ApiEnvironment.production:
        return baseUrlProduction;
    }
  }

  // ============================================
  // TIMEOUTS
  // ============================================
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ============================================
  // AUTHENTICATION ENDPOINTS
  // ============================================
  
  /// POST - Login with email/phone + password
  static const String login = '/client/login';
  
  /// POST - Register new client
  static const String register = '/client/register';
  
  /// POST - Logout and revoke tokens
  static const String logout = '/client/logout';
  
  /// GET - Get current authenticated client profile
  static const String me = '/client/me';

  // ============================================
  // PRODUCT CATALOG ENDPOINTS (PUBLIC)
  // ============================================
  
  /// GET - List all active products (paginated)
  static const String products = '/products';
  
  /// GET - Get single product details
  /// Usage: '${ApiConstants.products}/$productId'
  static String product(int id) => '/products/$id';
  
  /// GET - List all categories
  static const String categories = '/categories';
  
  /// GET - List all brands
  static const String brands = '/brands';

  // ============================================
  // CART ENDPOINTS (AUTH REQUIRED)
  // ============================================
  
  /// GET - Get cart items
  /// POST - Add item to cart
  static const String cart = '/client/cart';
  
  /// PUT - Update cart item quantity
  /// DELETE - Remove cart item
  /// Usage: '${ApiConstants.cart}/$cartItemId'
  static String cartItem(int id) => '/client/cart/$id';

  // ============================================
  // ORDER ENDPOINTS (AUTH REQUIRED)
  // ============================================
  
  /// GET - Get order history
  /// POST - Create new order
  static const String orders = '/client/orders';
  
  /// GET - Get single order details
  /// Usage: '${ApiConstants.orders}/$orderId'
  static String order(int id) => '/client/orders/$id';

  // ============================================
  // FAVORITES ENDPOINTS (AUTH REQUIRED)
  // ============================================
  
  /// GET - Get favorites list
  /// POST - Toggle favorite
  static const String favorites = '/client/favorites';

  // ============================================
  // HEALTH CHECK
  // ============================================
  
  /// GET - API health check
  static const String ping = '/ping';
}
