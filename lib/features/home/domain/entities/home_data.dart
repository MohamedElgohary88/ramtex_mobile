import 'package:equatable/equatable.dart';
import 'brand_entity.dart';
import 'category_entity.dart';
import 'product_entity.dart';

/// Container entity for all home screen data
/// Allows fetching/passing all necessary data at once
class HomeData extends Equatable {
  final List<CategoryEntity> categories;
  final List<BrandEntity> brands;
  final List<ProductEntity> featuredProducts;

  const HomeData({
    required this.categories,
    required this.brands,
    required this.featuredProducts,
  });

  @override
  List<Object?> get props => [categories, brands, featuredProducts];
}
