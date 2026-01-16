import '../../../../core/common/result.dart';
import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<Result<CartEntity>> getCart();
  Future<Result<CartEntity>> addToCart(int productId, int quantity);
  Future<Result<CartEntity>> updateQuantity(int cartItemId, int quantity);
  Future<Result<CartEntity>> removeFromCart(int cartItemId);
  Future<Result<void>> clearCart();
}
