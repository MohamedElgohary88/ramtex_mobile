import 'package:ramtex_mobile/features/home/data/models/category_model.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.price,
    super.oldPrice,
    super.imageUrl,
    required super.inStock,
    super.isFavorite = false,
    super.description,
    super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle price being int or double from API
    final priceVal = json['price'];
    final double price = priceVal is int ? priceVal.toDouble() : (priceVal as double? ?? 0.0);
    
    final oldPriceVal = json['old_price'];
    final double? oldPrice = oldPriceVal is int ? oldPriceVal.toDouble() : (oldPriceVal as double?);

    return ProductModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      price: price,
      oldPrice: oldPrice,
      imageUrl: json['image_url'] as String?,
      inStock: json['in_stock'] as bool? ?? true,
      isFavorite: json['is_favorite'] as bool? ?? false,
      description: json['description'] as String?,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }
}
