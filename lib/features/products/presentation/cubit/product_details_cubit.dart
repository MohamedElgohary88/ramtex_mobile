import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/result.dart';
import '../../../cart/domain/repositories/cart_repository.dart';
import '../../domain/repositories/products_repository.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductsRepository _productsRepository;
  final CartRepository _cartRepository;

  ProductDetailsCubit({
    required ProductsRepository productsRepository,
    required CartRepository cartRepository,
  })  : _productsRepository = productsRepository,
        _cartRepository = cartRepository,
        super(const ProductDetailsInitial());

  Future<void> loadProduct(int productId) async {
    emit(const ProductDetailsLoading());

    final result = await _productsRepository.getProductById(productId);

    switch (result) {
      case Success(data: final product):
        emit(ProductDetailsLoaded(product: product));
      case FailureResult(failure: final failure):
        emit(ProductDetailsError(failure.message));
    }
  }

  void incrementQuantity() {
    final currentState = state;
    if (currentState is! ProductDetailsLoaded) return;

    final maxQty = currentState.product.stockAvailable;
    if (currentState.selectedQuantity < maxQty) {
      emit(currentState.copyWith(
        selectedQuantity: currentState.selectedQuantity + 1,
      ));
    }
  }

  void decrementQuantity() {
    final currentState = state;
    if (currentState is! ProductDetailsLoaded) return;

    if (currentState.selectedQuantity > 1) {
      emit(currentState.copyWith(
        selectedQuantity: currentState.selectedQuantity - 1,
      ));
    }
  }

  void setQuantity(int quantity) {
    final currentState = state;
    if (currentState is! ProductDetailsLoaded) return;

    final maxQty = currentState.product.stockAvailable;
    final clampedQty = quantity.clamp(1, maxQty > 0 ? maxQty : 1);
    emit(currentState.copyWith(selectedQuantity: clampedQty));
  }

  Future<bool> addToCart() async {
    final currentState = state;
    if (currentState is! ProductDetailsLoaded) return false;

    emit(currentState.copyWith(isAddingToCart: true));

    final result = await _cartRepository.addToCart(
      currentState.product.id,
      currentState.selectedQuantity,
    );

    switch (result) {
      case Success():
        emit(currentState.copyWith(isAddingToCart: false));
        return true;
      case FailureResult():
        emit(currentState.copyWith(isAddingToCart: false));
        return false;
    }
  }
}
