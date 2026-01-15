import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Service for managing JWT tokens and sensitive data.
/// 
/// Uses flutter_secure_storage to store data in:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences
class SecureStorageService {
  SecureStorageService._internal();
  
  static final SecureStorageService _instance = SecureStorageService._internal();
  
  factory SecureStorageService() => _instance;
  
  static SecureStorageService get instance => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ============================================
  // STORAGE KEYS
  // ============================================
  
  static const String _tokenKey = 'auth_token';
  static const String _clientIdKey = 'client_id';
  static const String _clientNameKey = 'client_name';
  static const String _clientEmailKey = 'client_email';

  // ============================================
  // TOKEN MANAGEMENT
  // ============================================

  /// Save JWT token to secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieve JWT token from secure storage
  /// Returns null if no token is stored
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Delete JWT token from secure storage
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Check if a valid token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ============================================
  // CLIENT INFO MANAGEMENT
  // ============================================

  /// Save client information after login
  Future<void> saveClientInfo({
    required int clientId,
    required String name,
    required String email,
  }) async {
    await _storage.write(key: _clientIdKey, value: clientId.toString());
    await _storage.write(key: _clientNameKey, value: name);
    await _storage.write(key: _clientEmailKey, value: email);
  }

  /// Get stored client ID
  Future<int?> getClientId() async {
    final id = await _storage.read(key: _clientIdKey);
    return id != null ? int.tryParse(id) : null;
  }

  /// Get stored client name
  Future<String?> getClientName() async {
    return await _storage.read(key: _clientNameKey);
  }

  /// Get stored client email
  Future<String?> getClientEmail() async {
    return await _storage.read(key: _clientEmailKey);
  }

  // ============================================
  // LOGOUT / CLEAR ALL
  // ============================================

  /// Clear all stored data (used on logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
