import '../../../../core/common/result.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../params/product_filter_params.dart';

/// Repository interface for Products
abstract class ProductsRepository {
  /// Fetch list of products based on filters
  /// Returns a Result containing a generic Map or a specific wrapper for Data + Meta
  /// ideally we want `(List<ProductEntity>, PaginationMeta)`
  /// For simplicity, we can return `List<ProductEntity>` and maybe handle meta internally
  /// or return a PaginatedResult wrapper.
  ///
  /// Let's return a special `PaginatedList<T>` or just `List<ProductEntity>`
  /// and assume the repository implementation handles pagination logic?
  /// No, the Cubit needs to know if there are more pages.
  /// So the return type should probably include current_page and last_page from meta.

  Future<Result<ProductListResult>> getProducts(ProductFilterParams params);
}

class ProductListResult {
  final List<ProductEntity> products;
  final int lastPage;

  const ProductListResult({required this.products, required this.lastPage});
}
