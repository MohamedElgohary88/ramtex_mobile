import '../../../../core/common/result.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../entities/product_details_entity.dart';
import '../params/product_filter_params.dart';

/// Repository interface for Products
abstract class ProductsRepository {
  /// Fetch list of products based on filters
  Future<Result<ProductListResult>> getProducts(ProductFilterParams params);
  
  /// Fetch single product details by ID
  Future<Result<ProductDetailsEntity>> getProductById(int productId);
}

class ProductListResult {
  final List<ProductEntity> products;
  final int lastPage;

  const ProductListResult({required this.products, required this.lastPage});
}

