import '../../../home/data/models/product_model.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
    required super.total,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Check if 'product' is nested or id
    // Assuming 'product' key contains the product object
    return CartItemModel(
      id: json['id'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      // API returns 'subtotal' for the item total price
      total:
          (json['subtotal'] as num?)?.toDouble() ??
          (json['total'] as num?)?.toDouble() ??
          0.0,
    );
  }
}
