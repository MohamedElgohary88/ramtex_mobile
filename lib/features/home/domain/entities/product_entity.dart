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

  ProductEntity copyWith({
    int? id,
    String? name,
    String? slug,
    double? price,
    double? oldPrice,
    String? imageUrl,
    bool? inStock,
    bool? isFavorite,
    String? description,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      inStock: inStock ?? this.inStock,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
    );
  }

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
