import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/brand_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<BrandModel>> getBrands();
  Future<List<ProductModel>> getFeaturedProducts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.categories);
    final data = response.data as Map<String, dynamic>;
    final List list = data['data'] as List? ?? [];
    return list.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<List<BrandModel>> getBrands() async {
    final response = await _apiClient.get(ApiConstants.brands);
    final data = response.data as Map<String, dynamic>;
    final List list = data['data'] as List? ?? [];
    return list.map((e) => BrandModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await _apiClient.get(
      ApiConstants.products,
      queryParameters: {'per_page': 10, 'sort': 'newest'},
    );
    final data = response.data as Map<String, dynamic>;
    final List list = data['data'] as List? ?? [];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }
}
