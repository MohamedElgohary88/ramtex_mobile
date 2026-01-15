import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final double price;
  final double? oldPrice;
  final String? imageUrl;
  final bool inStock;
  final bool isFavorite;
  final String? description;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    this.oldPrice,
    this.imageUrl,
    required this.inStock,
    this.isFavorite = false,
    this.description,
  });

  bool get onSale => oldPrice != null && oldPrice! > price;

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        price,
        oldPrice,
        imageUrl,
        inStock,
        isFavorite,
        description,
      ];
}
