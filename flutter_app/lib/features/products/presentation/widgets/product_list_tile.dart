import 'package:catalog/core/theme/index.dart';
import 'package:catalog/core/utils/app_formats.dart';
import 'package:catalog/features/cart/presentation/widgets/in_cart_pill.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    required this.product,
    required this.onTap,
    required this.onAdd,
    this.cartQuantity = 0,
    super.key,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final int cartQuantity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: InCartShape.of(context, inCart: cartQuantity > 0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.tilePadding),
          child: Row(
            spacing: AppSpacing.tileGap,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ProductThumbnail(
                    url: product.thumbnail,
                    size: AppSizes.listTileThumbnail,
                  ),
                  if (cartQuantity > 0)
                    Positioned(
                      top: AppSpacing.badgeOffset,
                      right: AppSpacing.badgeOffset,
                      child: InCartPill(quantity: cartQuantity),
                    ),
                ],
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
              IconButton(
                tooltip: AppLang.of(context).addToCart,
                onPressed: onAdd,
                style: IconButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
                icon: const Icon(Icons.add),
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
