import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? company;
  final String? city;
  final String? country;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.company,
    this.city,
    this.country,
  });

  @override
  List<Object?> get props => [id, name, email, phone, company, city, country];
}
