import '../../../home/domain/entities/product_entity.dart';
import '../../domain/params/product_filter_params.dart';

sealed class ProductListState {
  const ProductListState();
}

class ProductListInitial extends ProductListState {
  const ProductListInitial();
}

class ProductListLoading extends ProductListState {
  const ProductListLoading();
}

class ProductListLoaded extends ProductListState {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  final ProductFilterParams params;

  const ProductListLoaded({
    required this.products,
    required this.hasReachedMax,
    required this.params,
  });

  ProductListLoaded copyWith({
    List<ProductEntity>? products,
    bool? hasReachedMax,
    ProductFilterParams? params,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      params: params ?? this.params,
    );
  }
}

class ProductListError extends ProductListState {
  final String message;
  const ProductListError(this.message);
}
