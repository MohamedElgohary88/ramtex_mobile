import '../../domain/entities/product_details_entity.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    required super.id,
    required super.name,
    required super.slug,
    super.itemCode,
    required super.price,
    super.oldPrice,
    super.imageUrl,
    super.description,
    required super.inStock,
    super.stockAvailable = 0,
    super.isFavorite = false,
    super.brand,
    super.category,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // Handle price being int or double
    final priceVal = json['price'];
    final double price =
        priceVal is int ? priceVal.toDouble() : (priceVal as double? ?? 0.0);

    final oldPriceVal = json['old_price'];
    final double? oldPrice =
        oldPriceVal is int ? oldPriceVal.toDouble() : (oldPriceVal as double?);

    // Parse brand
    BrandInfo? brand;
    if (json['brand'] != null && json['brand'] is Map) {
      final brandData = json['brand'] as Map<String, dynamic>;
      brand = BrandInfo(
        id: brandData['id'] as int? ?? 0,
        name: brandData['name'] as String? ?? '',
        slug: brandData['slug'] as String?,
        logoUrl: brandData['logo_url'] as String?,
      );
    }

    // Parse category
    CategoryInfo? category;
    if (json['category'] != null && json['category'] is Map) {
      final catData = json['category'] as Map<String, dynamic>;
      category = CategoryInfo(
        id: catData['id'] as int? ?? 0,
        name: catData['name'] as String? ?? '',
        slug: catData['slug'] as String?,
      );
    }

    return ProductDetailsModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      itemCode: json['item_code'] as String?,
      price: price,
      oldPrice: oldPrice,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
      inStock: json['in_stock'] as bool? ?? true,
      stockAvailable: json['stock_available'] as int? ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      brand: brand,
      category: category,
    );
  }
}
