import '../../domain/entities/user_entity.dart';

/// User Model for data layer
/// 
/// Handles JSON serialization/deserialization from API responses.
/// Extends [UserEntity] from domain layer.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.companyName,
    super.city,
    super.country,
    required super.token,
    super.createdAt,
  });

  /// Create UserModel from API JSON response
  /// 
  /// Expected structure:
  /// ```json
  /// {
  ///   "token": "...",
  ///   "client": {
  ///     "id": 1,
  ///     "name": "...",
  ///     "email": "...",
  ///     ...
  ///   }
  /// }
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final client = json['client'] as Map<String, dynamic>? ?? json;
    final token = json['token'] as String? ?? '';

    return UserModel(
      id: client['id'] as int? ?? 0,
      name: client['name'] as String? ?? '',
      email: client['email'] as String? ?? '',
      phone: client['phone'] as String? ?? '',
      companyName: client['company_name'] as String?,
      city: client['city'] as String?,
      country: client['country'] as String?,
      token: token,
      createdAt: client['created_at'] != null
          ? DateTime.tryParse(client['created_at'] as String)
          : null,
    );
  }

  /// Create UserModel from [UserEntity]
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      companyName: entity.companyName,
      city: entity.city,
      country: entity.country,
      token: entity.token,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to JSON (for caching or debugging)
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'client': {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'company_name': companyName,
        'city': city,
        'country': country,
        'created_at': createdAt?.toIso8601String(),
      },
    };
  }

  /// Create a copy with updated token
  UserModel copyWithToken(String newToken) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      companyName: companyName,
      city: city,
      country: country,
      token: newToken,
      createdAt: createdAt,
    );
  }
}
