import 'package:dartz/dartz.dart';
import 'package:ramtex_mobile/core/constants/api_constants.dart';
import 'package:ramtex_mobile/core/network/api_client.dart';

import 'package:ramtex_mobile/features/orders/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<Unit> placeOrder(String? notes);
  Future<List<OrderModel>> getOrders(int page);
  Future<OrderModel> getOrderDetails(int id);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Unit> placeOrder(String? notes) async {
    await apiClient.post(
      ApiConstants.orders, // Endpoint: /api/client/orders (apiClient handles base)
      data: {if (notes != null) 'notes': notes},
    );
    // 201 Created is expected
    return unit;
  }

  @override
  Future<List<OrderModel>> getOrders(int page) async {
    final response = await apiClient.get(
      ApiConstants.orders,
      queryParameters: {'per_page': 10, 'page': page},
    );

    if (response.data['data'] != null) {
      return (response.data['data'] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // NEW ENDPOINT implementation
  @override
  Future<OrderModel> getOrderDetails(int id) async {
    final response = await apiClient.get('${ApiConstants.orders}/$id');

    // Check if data is wrapped in 'data' key or direct
    final data = response.data['data'] ?? response.data;
    return OrderModel.fromJson(data);
  }
}
