import 'package:equatable/equatable.dart';

class BrandEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? logoUrl;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, slug, logoUrl];
}
