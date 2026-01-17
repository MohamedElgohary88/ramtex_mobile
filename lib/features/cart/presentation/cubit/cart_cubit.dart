import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/result.dart';
import 'package:ramtex_mobile/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ramtex_mobile/features/cart/domain/repositories/cart_repository.dart';
import 'package:ramtex_mobile/features/orders/domain/repositories/order_repository.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;
  final OrderRepository orderRepository;

  CartCubit({required this.repository, required this.orderRepository})
    : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());
    final result = await repository.getCart();
    switch (result) {
      case Success(data: final cart):
        emit(CartLoaded(cart));
      case FailureResult(failure: final failure):
        emit(CartError(failure.message));
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    final result = await repository.addToCart(productId, quantity);
    switch (result) {
      case Success(data: final cart):
        emit(CartLoaded(cart));
      case FailureResult(failure: final failure):
        emit(CartError(failure.message));
    }
  }

  Future<void> updateQuantity(int cartItemId, int quantity) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    // Optimistic UI: Show spinner on item
    emit(
      currentState.copyWith(
        loadingItemIds: {...currentState.loadingItemIds, cartItemId},
      ),
    );

    final result = await repository.updateQuantity(cartItemId, quantity);

    switch (result) {
      case Success(data: final resultCart):
        // Merge logic:
        // If resultCart has only 1 item and we have multiple, assumes it's a partial update
        // matching the cartItemId.
        // Or if we just want to be safe, we merge the specific item.

        List<CartItemEntity> updatedItems = List.from(currentState.cart.items);

        // Find the item to update
        final index = updatedItems.indexWhere((item) => item.id == cartItemId);
        if (index != -1 && resultCart.items.isNotEmpty) {
          // If result returns the updated item (Logic for PUT /cart/{id})
          // We assume resultCart.items.first is the updated one.
          // However, if resultCart.items has list, we might look for it.

          if (resultCart.items.length == 1) {
            updatedItems[index] = resultCart.items.first;
          } else {
            // If full list returned, use it
            updatedItems = resultCart.items;
          }
        }

        // Use totals from resultCart as they are authoritative
        final updatedCart = currentState.cart.copyWith(
          items: updatedItems,
          subtotal: resultCart.subtotal,
          tax: resultCart.tax,
          total: resultCart.total,
        );

        emit(CartLoaded(updatedCart));

      case FailureResult():
        // Revert loading state
        emit(
          currentState.copyWith(
            loadingItemIds: currentState.loadingItemIds
                .where((id) => id != cartItemId)
                .toSet(),
          ),
        );
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(
      currentState.copyWith(
        loadingItemIds: {...currentState.loadingItemIds, cartItemId},
      ),
    );

    final result = await repository.removeFromCart(cartItemId);
    switch (result) {
      case Success(data: final resultCart):
        // If result is empty list, it means cart is empty OR item deleted and list returned?
        // If resultCart items is NOT empty, we use it (assuming full list).
        // If it IS empty, we check if it was supposed to be empty.

        List<CartItemEntity> updatedItems;
        if (resultCart.items.isNotEmpty) {
          updatedItems = resultCart.items;
        } else {
          // If response has empty items, and we had many, it might be weird.
          // Note: If DELETE returns empty data/list, safe to assume we just remove locally.
          updatedItems = List.from(currentState.cart.items)
            ..removeWhere((item) => item.id == cartItemId);
        }

        final updatedCart = currentState.cart.copyWith(
          items: updatedItems,
          subtotal: resultCart.total > 0
              ? resultCart.subtotal
              : 0.0, // Fallback safety
          total: resultCart.total,
        );

        emit(CartLoaded(updatedCart));

      case FailureResult():
        emit(
          currentState.copyWith(
            loadingItemIds: currentState.loadingItemIds
                .where((id) => id != cartItemId)
                .toSet(),
          ),
        );
    }
  }
  Future<bool> checkout(String? notes) async {
    // 1. Emit loading or separate checkout loading state?
    // Using CartLoading might hide the cart. Let's assume the UI handles it via a bool or separate state.
    // For now, let's keep it simple: Just return result or emit error.
    // Ideally, we should have a `isCheckingOut` flag in CartLoaded.
    // But since CartState is sealed, adding a field is hard without refactor.
    // Alternative: Just return success/failure boolean and let UI show spinner.
    // Or simpler: Emit CartLoading (which shows spinner) then CartLoaded (empty).

    emit(CartLoading());
    final result = await orderRepository.placeOrder(notes);

    return result.fold(
      (failure) {
        emit(CartError(failure.message));
        return false;
      },
      (_) async {
        // Success! Cart is cleared on server. Reload cart to get empty state.
        await loadCart();
        return true;
      },
    );
  }
}
