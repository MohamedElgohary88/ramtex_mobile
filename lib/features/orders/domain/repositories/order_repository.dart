import 'package:dartz/dartz.dart';
import 'package:ramtex_mobile/core/errors/failures.dart';
import 'package:ramtex_mobile/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  /// Places a new order with optional notes.
  /// Returns Unit (void) on success or Failure.
  Future<Either<Failure, Unit>> placeOrder(String? notes);

  /// Fetches a paginated list of orders.
  Future<Either<Failure, List<OrderEntity>>> getOrders(int page);

  /// Fetches full details for a specific order by ID.
  Future<Either<Failure, OrderEntity>> getOrderDetails(int id);
}
