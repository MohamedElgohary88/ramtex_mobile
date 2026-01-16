import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/result.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../../home/domain/entities/product_entity.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesCubit({required this.repository}) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    final result = await repository.getFavorites();
    switch (result) {
      case Success(data: final data):
        emit(FavoritesLoaded(data));
      case FailureResult(failure: final failure):
        emit(FavoritesError(failure.message));
    }
  }

  Future<void> toggleFavorite(ProductEntity product) async {
    // Current state check
    List<ProductEntity> currentFavorites = [];
    if (state is FavoritesLoaded) {
      currentFavorites = List.from((state as FavoritesLoaded).favorites);
    }

    // Optimistic Update
    final isFavorite = currentFavorites.any((p) => p.id == product.id);
    if (isFavorite) {
      currentFavorites.removeWhere((p) => p.id == product.id);
    } else {
      currentFavorites.add(product.copyWith(isFavorite: true));
    }

    // Emit optimistic state immediately
    emit(FavoritesLoaded(currentFavorites));

    // API Call (Assuming product.id is non-null for logic, though ProductEntity id is int)
    final result = await repository.toggleFavorite(product.id);

    // Rollback on failure
    switch (result) {
      case Success():
        // Success
        break;
      case FailureResult():
        // Revert by reloading to ensure sync
        loadFavorites();
        break;
    }
  }

  bool isFavorite(int productId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favorites.any((p) => p.id == productId);
    }
    return false;
  }
}
