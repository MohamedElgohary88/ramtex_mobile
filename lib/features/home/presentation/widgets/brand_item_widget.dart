import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/brand_entity.dart';

class BrandItemWidget extends StatelessWidget {
  final BrandEntity brand;
  final VoidCallback? onTap;

  const BrandItemWidget({
    super.key,
    required this.brand,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 60,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: brand.logoUrl != null
            ? CachedNetworkImage(
                imageUrl: brand.logoUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 1)),
                errorWidget: (context, url, error) => const Icon(Icons.branding_watermark, color: Colors.grey),
              )
            : Center(
                child: Text(
                  brand.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
