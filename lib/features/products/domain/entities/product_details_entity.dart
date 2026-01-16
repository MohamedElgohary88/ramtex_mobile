import 'package:equatable/equatable.dart';

/// Extended Product Entity for Product Details screen
/// Includes additional fields: brand, category, stock_available, item_code
class ProductDetailsEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? itemCode;
  final double price;
  final double? oldPrice;
  final String? imageUrl;
  final String? description;
  final bool inStock;
  final int stockAvailable;
  final bool isFavorite;
  final BrandInfo? brand;
  final CategoryInfo? category;

  const ProductDetailsEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.itemCode,
    required this.price,
    this.oldPrice,
    this.imageUrl,
    this.description,
    required this.inStock,
    this.stockAvailable = 0,
    this.isFavorite = false,
    this.brand,
    this.category,
  });

  bool get onSale => oldPrice != null && oldPrice! > price;
  bool get isLowStock => stockAvailable > 0 && stockAvailable < 10;

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        itemCode,
        price,
        oldPrice,
        imageUrl,
        description,
        inStock,
        stockAvailable,
        isFavorite,
        brand,
        category,
      ];
}

/// Brand information embedded in product details
class BrandInfo extends Equatable {
  final int id;
  final String name;
  final String? slug;
  final String? logoUrl;

  const BrandInfo({
    required this.id,
    required this.name,
    this.slug,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, slug, logoUrl];
}

/// Category information embedded in product details
class CategoryInfo extends Equatable {
  final int id;
  final String name;
  final String? slug;

  const CategoryInfo({
    required this.id,
    required this.name,
    this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}
