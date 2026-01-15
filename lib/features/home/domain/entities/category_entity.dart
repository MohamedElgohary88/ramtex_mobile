import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? imageUrl;
  final String? description;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, slug, imageUrl, description];
}
