import 'package:equatable/equatable.dart';

/// User Entity representing an authenticated client.
/// 
/// This is the domain layer representation of a user.
/// Contains only the essential data needed by the UI.
class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? companyName;
  final String? city;
  final String? country;
  final String token;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.companyName,
    this.city,
    this.country,
    required this.token,
    this.createdAt,
  });

  /// Create an empty/guest user
  factory UserEntity.guest() => const UserEntity(
        id: 0,
        name: 'Guest',
        email: '',
        phone: '',
        token: '',
      );

  /// Check if user is authenticated
  bool get isAuthenticated => token.isNotEmpty;

  /// Get display name (first name only)
  String get firstName => name.split(' ').first;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        companyName,
        city,
        country,
        token,
        createdAt,
      ];
}
