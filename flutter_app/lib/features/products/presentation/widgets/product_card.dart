import 'package:catalog/core/theme/index.dart';
import 'package:catalog/core/utils/app_formats.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, required this.onTap, super.key});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ColoredBox(
                color: colors.imageSurface,
                child: Center(
                  child: Image.network(
                    product.thumbnail,
                    width: AppSizes.productCardImage,
                    height: AppSizes.productCardImage,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      color: colors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardContent,
                AppSpacing.cardContentTop,
                AppSpacing.cardContent,
                AppSpacing.cardContent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.cardContentGap,
                children: [
                  Text(
                    product.title,
                    style: AppTextStyles.productCardTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppFormats.price(product.price),
                        style: AppTextStyles.priceSmall,
                      ),
                      ProductRating(value: product.rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductRating extends StatelessWidget {
  const ProductRating({required this.value, super.key});

  final double value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.ratingGap,
      children: [
        Icon(Icons.star, size: AppSizes.ratingStar, color: colors.rating),
        Text(
          AppFormats.rating(value),
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}
