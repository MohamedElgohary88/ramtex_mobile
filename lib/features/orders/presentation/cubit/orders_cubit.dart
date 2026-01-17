import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramtex_mobile/features/orders/domain/repositories/order_repository.dart';
import 'package:ramtex_mobile/features/orders/presentation/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository repository;

  OrdersCubit({required this.repository}) : super(OrdersInitial());

  Future<void> loadOrders({bool refresh = false}) async {
    if (state is OrdersLoading) return;

    final currentState = state;
    var oldOrders = <dynamic>[];
    var page = 1;

    if (currentState is OrdersLoaded && !refresh) {
      if (currentState.hasReachedMax) return;
      oldOrders = currentState.orders;
      page = currentState.page + 1;
    } else {
      emit(OrdersLoading());
    }

    final result = await repository.getOrders(page);

    result.fold((failure) => emit(OrdersError(failure.message)), (newOrders) {
      final isMax =
          newOrders.isEmpty || newOrders.length < 10; // Assuming per_page=10
      emit(
        OrdersLoaded(
          orders: refresh ? newOrders : [...oldOrders, ...newOrders],
          hasReachedMax: isMax,
          page: page,
        ),
      );
    });
  }
}
