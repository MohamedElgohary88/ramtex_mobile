import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class FavoriteButton extends StatelessWidget {
  final ProductEntity product;
  final double size;

  const FavoriteButton({super.key, required this.product, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        bool isFavorite = product.isFavorite;

        if (state is FavoritesLoaded) {
          isFavorite = state.favorites.any((p) => p.id == product.id);
        }

        return GestureDetector(
          onTap: () {
            context.read<FavoritesCubit>().toggleFavorite(product);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
              size: size,
            ),
          ),
        );
      },
    );
  }
}
