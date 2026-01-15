import '../../../../core/network/api_client.dart';
import '../../../home/data/models/product_model.dart';
import '../../domain/params/product_filter_params.dart';

abstract class ProductsRemoteDataSource {
  Future<ProductListResponse> getProducts(ProductFilterParams params);
}

class ProductListResponse {
  final List<ProductModel> products;
  final int lastPage;

  ProductListResponse({required this.products, required this.lastPage});
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final ApiClient _apiClient;

  ProductsRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<ProductListResponse> getProducts(ProductFilterParams params) async {
    // Determine query params
    final queryParams = params.toMap();

    final response = await _apiClient.get(
      '/products',
      queryParameters: queryParams,
    );

    // Parse response
    // Structure: { data: [...], meta: { current_page: 1, last_page: 5, ... } }
    final data = response.data['data'] as List;
    final meta = response.data['meta'] as Map<String, dynamic>;

    final products = data.map((e) => ProductModel.fromJson(e)).toList();
    final lastPage = meta['last_page'] as int? ?? 1;

    return ProductListResponse(products: products, lastPage: lastPage);
  }
}
