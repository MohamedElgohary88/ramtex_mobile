import '../../domain/entities/cart_entity.dart';

sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartEntity cart;
  /// IDs of cart items currently being updated (quantity change or removal)
  final Set<int> loadingItemIds;

  const CartLoaded(this.cart, {this.loadingItemIds = const {}});
  
  CartLoaded copyWith({CartEntity? cart, Set<int>? loadingItemIds}) {
    return CartLoaded(
      cart ?? this.cart,
      loadingItemIds: loadingItemIds ?? this.loadingItemIds,
    );
  }
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
}
