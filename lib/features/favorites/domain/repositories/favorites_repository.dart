import '../../../../core/common/result.dart';
import '../../../home/domain/entities/product_entity.dart';

abstract class FavoritesRepository {
  Future<Result<List<ProductEntity>>> getFavorites();
  Future<Result<void>> toggleFavorite(int productId);
}
