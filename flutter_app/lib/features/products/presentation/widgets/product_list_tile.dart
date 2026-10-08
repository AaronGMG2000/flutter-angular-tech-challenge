import 'package:catalog/core/theme/index.dart';
import 'package:catalog/core/utils/app_formats.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    required this.product,
    required this.onTap,
    super.key,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.tilePadding),
          child: Row(
            spacing: AppSpacing.tileGap,
            children: [
              ProductThumbnail(
                url: product.thumbnail,
                size: AppSizes.listTileThumbnail,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.tileTextGap,
                  children: [
                    Text(
                      product.title,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      spacing: AppSpacing.ratingGap,
                      children: [
                        Icon(
                          Icons.star,
                          size: AppSizes.ratingStar,
                          color: colors.rating,
                        ),
                        Flexible(
                          child: Text(
                            '${AppFormats.rating(product.rating)} · '
                            '${product.category}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppFormats.price(product.price),
                      style: AppTextStyles.priceSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail({required this.url, required this.size, super.key});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.thumbnail),
      child: ColoredBox(
        color: colors.imageSurface,
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => SizedBox.square(
            dimension: size,
            child: Icon(Icons.image_not_supported, color: colors.textTertiary),
          ),
        ),
      ),
    );
  }
}
