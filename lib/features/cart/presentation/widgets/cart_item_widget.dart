import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final isLoading =
            state is CartLoaded && state.loadingItemIds.contains(item.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl:
                        item.product.imageUrl ??
                        'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info & Controls
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Remove
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.product.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.grey, // Subtle
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: isLoading
                              ? null
                              : () => context.read<CartCubit>().removeFromCart(
                                  item.id,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Price
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.accent, // Accent Color
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quantity Controls
                    Row(
                      children: [
                        _buildQtyBtn(
                          icon: item.quantity > 1
                              ? Icons.remove
                              : Icons.delete_outline,
                          iconColor: item.quantity > 1
                              ? AppColors.textPrimary
                              : AppColors.error,
                          onTap: () {
                            if (item.quantity > 1) {
                              context.read<CartCubit>().updateQuantity(
                                item.id,
                                item.quantity - 1,
                              );
                            } else {
                              context.read<CartCubit>().removeFromCart(item.id);
                            }
                          },
                          enabled: !isLoading,
                        ),
                        Container(
                          width: 36,
                          alignment: Alignment.center,
                          child: isLoading
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  '${item.quantity}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                        ),
                        _buildQtyBtn(
                          icon: Icons.add,
                          onTap: () {
                            context.read<CartCubit>().updateQuantity(
                              item.id,
                              item.quantity + 1,
                            );
                          },
                          enabled: !isLoading,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQtyBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
          color: enabled ? Colors.white : Colors.grey.shade50,
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? (iconColor ?? AppColors.textPrimary) : Colors.grey,
        ),
      ),
    );
  }
}
