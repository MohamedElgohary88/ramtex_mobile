import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    // API Structure:
    // GET: { "data": [ ... items ... ], "totals": { ... } }
    // PUT: { "data": { ... 1 item ... }, "totals": { ... } }

    List<CartItemModel> items = [];
    final data = json['data'];

    if (data != null) {
      if (data is List) {
        items = data.map((e) => CartItemModel.fromJson(e)).toList();
      } else if (data is Map<String, dynamic>) {
        // Single item update response
        items.add(CartItemModel.fromJson(data));
      }
    }

    // Parse Totals
    double total = 0.0;
    double subtotal = 0.0;

    if (json['totals'] != null && json['totals'] is Map) {
      final totals = json['totals'];
      total = (totals['grand_total'] as num?)?.toDouble() ?? 0.0;
      subtotal = (totals['subtotal'] as num?)?.toDouble() ?? total;
    } else {
      // Fallback
      subtotal = _calculateSubtotal(items);
      total = _calculateTotal(items);
    }

    return CartModel(items: items, subtotal: subtotal, tax: 0, total: total);
  }

  // Fallback for calculating totals if backend sends only list
  factory CartModel.fromItems(List<CartItemModel> items) {
    final subtotal = _calculateSubtotal(items);
    return CartModel(items: items, subtotal: subtotal, tax: 0, total: subtotal);
  }

  static double _calculateSubtotal(List<CartItemModel> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  static double _calculateTotal(List<CartItemModel> items) {
    // Simplifying: total = subtotal for fallback
    return items.fold(0.0, (sum, item) => sum + item.total);
  }
}
