import 'package:equatable/equatable.dart';
import '../../domain/entities/product_details_entity.dart';

sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {
  const ProductDetailsInitial();
}

class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsEntity product;
  final int selectedQuantity;
  final bool isAddingToCart;

  const ProductDetailsLoaded({
    required this.product,
    this.selectedQuantity = 1,
    this.isAddingToCart = false,
  });

  ProductDetailsLoaded copyWith({
    ProductDetailsEntity? product,
    int? selectedQuantity,
    bool? isAddingToCart,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
    );
  }

  @override
  List<Object?> get props => [product, selectedQuantity, isAddingToCart];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
