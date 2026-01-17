import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramtex_mobile/features/orders/domain/repositories/order_repository.dart';
import 'package:ramtex_mobile/features/orders/presentation/cubit/order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderRepository repository;

  OrderDetailsCubit({required this.repository}) : super(OrderDetailsInitial());

  Future<void> loadOrderDetails(int id) async {
    emit(OrderDetailsLoading());
    final result = await repository.getOrderDetails(id);
    result.fold(
      (failure) => emit(OrderDetailsError(failure.message)),
      (order) => emit(OrderDetailsLoaded(order)),
    );
  }
}
