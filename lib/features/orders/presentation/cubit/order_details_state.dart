import 'package:equatable/equatable.dart';
import 'package:ramtex_mobile/features/orders/domain/entities/order_entity.dart';

sealed class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object> get props => [];
}

final class OrderDetailsInitial extends OrderDetailsState {}

final class OrderDetailsLoading extends OrderDetailsState {}

final class OrderDetailsLoaded extends OrderDetailsState {
  final OrderEntity order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object> get props => [order];
}

final class OrderDetailsError extends OrderDetailsState {
  final String message;

  const OrderDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
