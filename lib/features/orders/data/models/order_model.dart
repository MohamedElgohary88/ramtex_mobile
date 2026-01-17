import 'package:ramtex_mobile/features/orders/domain/entities/order_entity.dart';
import 'package:ramtex_mobile/features/orders/data/models/order_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.invoiceNumber,
    required super.totalAmount,
    super.subtotal,
    super.tax,
    super.vatAmount,
    super.grandTotal,
    required super.status,
    required super.date,
    super.invoiceDate,
    super.notes,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      invoiceNumber: json['invoice_number'] ?? 'INV-#${json['id']}',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      vatAmount: (json['vat_amount'] as num?)?.toDouble(),
      grandTotal: (json['grand_total'] as num?)?.toDouble(),
      // Map 'status' string to OrderStatus enum
      status: _mapStatus(json['status']),
      date: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      invoiceDate: DateTime.tryParse(json['invoice_date'] ?? ''),
      notes: json['notes'],
      items: json['items'] != null
          ? (json['items'] as List)
                .map((e) => OrderItemModel.fromJson(e))
                .toList()
          : [],
    );
  }

  static OrderStatus _mapStatus(String? status) {
    if (status == null) return OrderStatus.unknown;
    switch (status.toLowerCase()) {
      case 'draft':
        return OrderStatus.draft;
      case 'posted':
        return OrderStatus.posted;
      case 'paid':
        return OrderStatus.paid;
      case 'shipped':
        return OrderStatus.shipped;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }
}
