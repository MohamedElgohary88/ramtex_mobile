import '../../../home/domain/entities/product_entity.dart';

class CartItemEntity {
  final int id;
  final ProductEntity product;
  final int quantity;
  final double total;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
    required this.total,
  });

  CartItemEntity copyWith({
    int? id,
    ProductEntity? product,
    int? quantity,
    double? total,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }
}
