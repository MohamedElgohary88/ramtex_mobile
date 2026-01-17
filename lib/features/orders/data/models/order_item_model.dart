import 'package:ramtex_mobile/features/home/data/models/product_model.dart';
import 'package:ramtex_mobile/features/orders/domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    super.product,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
    required super.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      productName: json['product'] != null
          ? json['product']['name'] ?? 'Unknown Product'
          : 'Unknown Product',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['total_line_price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
