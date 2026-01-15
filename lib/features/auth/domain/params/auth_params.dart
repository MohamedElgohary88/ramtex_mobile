import 'package:equatable/equatable.dart';

/// Parameters for login request
class LoginParams extends Equatable {
  final String? email;
  final String? phone;
  final String password;

  const LoginParams({
    this.email,
    this.phone,
    required this.password,
  }) : assert(
          email != null || phone != null,
          'Either email or phone must be provided',
        );

  /// Create login params with email
  factory LoginParams.withEmail({
    required String email,
    required String password,
  }) =>
      LoginParams(email: email, password: password);

  /// Create login params with phone
  factory LoginParams.withPhone({
    required String phone,
    required String password,
  }) =>
      LoginParams(phone: phone, password: password);

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'password': password,
    };
    if (email != null && email!.isNotEmpty) {
      map['email'] = email;
    }
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone;
    }
    return map;
  }

  @override
  List<Object?> get props => [email, phone, password];
}

/// Parameters for registration request
class RegisterParams extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String? companyName;
  final String? city;
  final String? country;

  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.companyName,
    this.city,
    this.country,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    if (companyName != null && companyName!.isNotEmpty) {
      map['company_name'] = companyName;
    }
    if (city != null && city!.isNotEmpty) {
      map['city'] = city;
    }
    if (country != null && country!.isNotEmpty) {
      map['country'] = country;
    }
    return map;
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        phone,
        password,
        passwordConfirmation,
        companyName,
        city,
        country,
      ];
}
