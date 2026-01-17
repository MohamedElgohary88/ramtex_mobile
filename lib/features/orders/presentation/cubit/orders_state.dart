import 'package:equatable/equatable.dart';
import 'package:ramtex_mobile/features/orders/domain/entities/order_entity.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;
  final bool hasReachedMax;
  final int page;

  const OrdersLoaded({
    required this.orders,
    this.hasReachedMax = false,
    required this.page,
  });

  OrdersLoaded copyWith({
    List<OrderEntity>? orders,
    bool? hasReachedMax,
    int? page,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [orders, hasReachedMax, page];
}

final class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
