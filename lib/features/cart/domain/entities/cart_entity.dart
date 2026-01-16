import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double total;

  const CartEntity({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  factory CartEntity.empty() =>
      const CartEntity(items: [], subtotal: 0, tax: 0, total: 0);

  CartEntity copyWith({
    List<CartItemEntity>? items,
    double? subtotal,
    double? tax,
    double? total,
  }) {
    return CartEntity(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [items, subtotal, tax, total];
}
