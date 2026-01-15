import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onFavoriteToggle;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate off percentage
    String? discountBadge;
    if (product.onSale && product.oldPrice != null) {
      final diff = product.oldPrice! - product.price;
      final percent = (diff / product.oldPrice!) * 100;
      if (percent > 0) {
        discountBadge = '${percent.round()}% OFF';
      }
    }

    return GestureDetector(
      onTap:
          onTap ??
          () => context.pushNamed(
            AppRouter.productDetails,
            pathParameters: {'id': product.id.toString()},
          ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16), // More rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06), // Softer shadow
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section (Relative Stack)
            Expanded(
              flex: 5, // give image slightly more space ratio
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Product Image
                  Hero(
                    // Hero animation for smooth transition
                    tag: 'product_${product.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Container(
                        color: AppColors.background, // Placeholder bg
                        child: product.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: product.imageUrl!,
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey,
                                      size: 32,
                                    ),
                              )
                            : const Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),

                  // Out of Stock Overlay
                  if (!product.inStock)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Sold Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Discount Badge (Top Left)
                  if (product.inStock && discountBadge != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          discountBadge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Button (Top Right)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onFavoriteToggle,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(
                              alpha: 0.9,
                            ), // Glassy look
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            size: 18,
                            color: product.isFavorite
                                ? Colors.red
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              // Prevents overflow
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Name (Optional)
                    // if (product.brandId != null) ...

                    // Title
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    
                    const Spacer(),

                    // Price & Action
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.onSale && product.oldPrice != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  '\$${product.oldPrice!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  ),
                              ),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors
                                    .textPrimary, // FIXED: High contrast
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Add to Cart Button (Mini FAB style)
                        if (product.inStock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onAddToCart,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.accent, // FIXED: Blue button
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ), // Squircle
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons
                                      .add_shopping_cart_rounded, // Specific icon
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
