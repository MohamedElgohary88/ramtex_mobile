import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

enum OrderStatus {
  draft,
  posted,
  paid,
  shipped,
  completed,
  cancelled,
  unknown;

  String get displayName {
    switch (this) {
      case OrderStatus.draft:
        return 'Draft';
      case OrderStatus.posted:
        return 'Posted';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.unknown:
        return 'Unknown';
    }
  }
}

class OrderEntity extends Equatable {
  final int id;
  final String invoiceNumber;
  final double totalAmount;
  final double? subtotal;
  final double? tax;
  final double? vatAmount;
  final double? grandTotal;
  final OrderStatus status;
  final DateTime date;
  final DateTime? invoiceDate;
  final String? notes;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.invoiceNumber,
    required this.totalAmount,
    this.subtotal,
    this.tax,
    this.vatAmount,
    this.grandTotal,
    required this.status,
    required this.date,
    this.invoiceDate,
    this.notes,
    required this.items,
  });

  @override
  List<Object?> get props => [
    id,
    invoiceNumber,
    totalAmount,
    subtotal,
    tax,
    vatAmount,
    grandTotal,
    status,
    date,
    invoiceDate,
    notes,
    items,
  ];
}
