import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/result.dart';
import '../../domain/params/product_filter_params.dart';
import '../../domain/repositories/products_repository.dart';
import 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ProductsRepository _repository;

  ProductListCubit({required ProductsRepository repository})
      : _repository = repository,
        super(const ProductListInitial());

  /// Initial load or filter change (resets list)
  Future<void> loadProducts({ProductFilterParams? params}) async {
    final currentParams = params ?? const ProductFilterParams();
    
    emit(const ProductListLoading());

    final result = await _repository.getProducts(currentParams);

    switch (result) {
      case Success(data: final data):
        emit(ProductListLoaded(
          products: data.products,
          hasReachedMax: currentParams.page >= data.lastPage,
          params: currentParams,
        ));
      case FailureResult(failure: final failure):
        emit(ProductListError(failure.message));
    }
  }

  /// Load more (pagination)
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ProductListLoaded) return;
    if (currentState.hasReachedMax) return;

    final nextParams = currentState.params.copyWith(
      page: currentState.params.page + 1,
    );

    // Fetch next page
    final result = await _repository.getProducts(nextParams);

    switch (result) {
      case Success(data: final data):
        emit(currentState.copyWith(
          products: [...currentState.products, ...data.products],
          hasReachedMax: nextParams.page >= data.lastPage,
          params: nextParams,
        ));
      case FailureResult(failure: final failure):
        // For pagination error, maybe show snackbar via listener, 
        // effectively we just don't update list or set error state?
        // Setting Error state would wipe the list which is bad UX.
        // For now, let's just emit same state or maybe a dedicated "PaginationError" if needed.
        // For simplicity: Do nothing but log? Or emit error?
        // Let's emit error for now, but UI should handle preserving list if possible.
        // Actually, cleaner is to NOT change state if failure, maybe emit a side effect.
        // But Cubit is state-only.
        // Let's keep it simple: emit Error. UI will rebuild.
        // Better defensive: Don't emit error if we have data, unless critical.
        // Ideally we'd have a `isLoadingMore` flag.
        // Let's stick to simple: if fail, show error.
         emit(ProductListError(failure.message));
    }
  }

  /// Update filters (resets list)
  Future<void> updateFilters(ProductFilterParams newParams) async {
    // Reset page to 1
    final paramsWithResetPage = newParams.copyWith(page: 1);
    await loadProducts(params: paramsWithResetPage);
  }
}
