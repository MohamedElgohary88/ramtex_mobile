import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<CartModel> addToCart(int productId, int quantity);
  Future<CartModel> updateQuantity(int cartItemId, int quantity);
  Future<CartModel> removeFromCart(int cartItemId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CartModel> getCart() async {
    final response = await apiClient.get(ApiConstants.cart);
    return CartModel.fromJson(response.data);
  }

  @override
  Future<CartModel> addToCart(int productId, int quantity) async {
    final response = await apiClient.post(
      ApiConstants.cart,
      data: {'product_id': productId, 'quantity': quantity},
    );
    // Assuming backend returns updated cart
    return CartModel.fromJson(response.data);
  }

  @override
  Future<CartModel> removeFromCart(int cartItemId) async {
    final response = await apiClient.delete(ApiConstants.cartItem(cartItemId));
    // Assuming backend returns updated cart
    return CartModel.fromJson(response.data);
  }

  @override
  Future<CartModel> updateQuantity(int cartItemId, int quantity) async {
    final response = await apiClient.put(
      ApiConstants.cartItem(cartItemId),
      data: {'quantity': quantity},
    );
    // Assuming backend returns updated cart
    return CartModel.fromJson(response.data);
  }

  @override
  Future<void> clearCart() async {
    // If there's an endpoint to clear all, use it. Otherwise loop?
    // Assuming DELETE /client/cart clears all? Unlikely.
    // For now, assuming standard one-by-one or specific endpoint.
    // I'll simulate or assume POST /clear endpoint if it exists?
    // ApiConstants doesn't have it.
    // I'll loop deletes? No, strict QA says "What if internet cuts off?".
    // I'll skip implementation or assume backend handles it via another call?
    // User didn't specify clear cart endpoint.
    // I'll leave it as unimplemented or simple loop (risky).
    // Actually, maybe just don't implement Clear Cart UI yet.
    // Or throw Unimplemented.
    throw UnimplementedError('Clear cart API not defined');
  }
}
