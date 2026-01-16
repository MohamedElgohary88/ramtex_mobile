import 'package:ramtex_mobile/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';

import '../../../home/data/models/product_model.dart';
import '../../../home/domain/entities/product_entity.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<ProductEntity>> getFavorites();
  Future<void> toggleFavorite(int productId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final ApiClient apiClient;

  FavoritesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductEntity>> getFavorites() async {
    final response = await apiClient.get(ApiConstants.favorites);
    // response is Response<dynamic> from Dio
    final dynamic data = response.data;

    // Check if data is Map and has 'data' key or is List
    List listData = [];
    if (data is Map && data.containsKey('data')) {
      listData = data['data'] ?? [];
    } else if (data is List) {
      listData = data;
    }

    return listData.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<void> toggleFavorite(int productId) async {
    await apiClient.post(ApiConstants.favorites, data: {'product_id': productId});
  }
}
