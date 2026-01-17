import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product_entity.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final ProductEntity? product; // Nullable in case product is deleted, but ideally should be there
  final String productName; // Snapshot of name
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItemEntity({
    required this.id,
    this.product,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [id, product, productName, quantity, unitPrice, subtotal];
}
