import 'package:catalog/core/theme/index.dart';
import 'package:catalog/core/utils/app_formats.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/presentation/widgets/product_detail_layout.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final lang = AppLang.of(context);
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return ProductDetailLayout(
      image: Image.network(
        product.images.firstOrNull ?? product.thumbnail,
        width: AppSizes.detailImage,
        height: AppSizes.detailImage,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.image_not_supported, color: colors.textTertiary),
      ),
      sheet: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sheetGap,
        children: [
          Wrap(
            spacing: AppSpacing.chipGap,
            runSpacing: AppSpacing.chipGap,
            children: [
              DetailTag(
                label: product.category,
                background: colors.categoryTagSurface,
                foreground: colors.categoryTagText,
              ),
              DetailTag(
                label: lang.inStock(product.stock),
                background: colors.successSurface,
                foreground: colors.successText,
              ),
            ],
          ),
          Text(product.title, style: textTheme.headlineSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: AppSpacing.priceRowGap,
            children: [
              Text(
                AppFormats.price(product.price),
                style: AppTextStyles.priceLarge,
              ),
              DiscountChip(percent: product.discountPercentage),
              const Spacer(),
              Icon(
                Icons.star,
                size: AppSizes.detailRatingStar,
                color: colors.rating,
              ),
              Text(
                AppFormats.rating(product.rating),
                style: textTheme.bodyMedium,
              ),
            ],
          ),
          Text(
            product.description,
            style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class DetailTag extends StatelessWidget {
  const DetailTag({
    required this.label,
    required this.background,
    required this.foreground,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.tagHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.tagHorizontal),
      decoration: ShapeDecoration(
        color: background,
        shape: const StadiumBorder(),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: foreground),
        ),
      ),
    );
  }
}

class DiscountChip extends StatelessWidget {
  const DiscountChip({required this.percent, super.key});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.discountSurface,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.discountHorizontal,
          vertical: AppSpacing.discountVertical,
        ),
        child: Text(
          AppFormats.discount(percent),
          style: AppTextStyles.discount.copyWith(color: colors.discountText),
        ),
      ),
    );
  }
}
