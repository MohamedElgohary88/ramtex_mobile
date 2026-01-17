import 'package:ramtex_mobile/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.company,
    super.city,
    super.country,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Check if wrapped in 'client'
    final data = json.containsKey('client') ? json['client'] : json;
    
    return ProfileModel(
      id: data['id'] as int? ?? 0,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      company: data['company'] as String?,
      city: data['city'] as String?,
      country: data['country'] as String?,
    );
  }
}
