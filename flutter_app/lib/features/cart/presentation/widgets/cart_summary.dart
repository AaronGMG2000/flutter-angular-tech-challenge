import 'package:catalog/core/theme/index.dart';
import 'package:catalog/core/utils/app_formats.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSummary extends ConsumerWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final lang = AppLang.of(context);
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final total = AppFormats.price(cart.total);
    final secondary = textTheme.bodyMedium?.copyWith(
      color: colors.onCartSummary.withValues(alpha: AppOpacity.summaryText),
    );

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.summaryMargin),
        padding: const EdgeInsets.all(AppSpacing.summaryPadding),
        decoration: BoxDecoration(
          color: colors.cartSummary,
          borderRadius: BorderRadius.circular(AppRadius.cartSummary),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sheetGap,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lang.cartSubtotal(cart.totalItems), style: secondary),
                Text(total, style: secondary),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lang.cartTotal,
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.onCartSummary,
                  ),
                ),
                Text(
                  total,
                  style: AppTextStyles.cartTotal.copyWith(color: colors.accent),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () => ref.read(cartProvider.notifier).clear(),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.onCartSummary,
                side: BorderSide(
                  color: colors.onCartSummary.withValues(
                    alpha: AppOpacity.summaryBorder,
                  ),
                ),
              ),
              child: Text(lang.clearCart),
            ),
          ],
        ),
      ),
    );
  }
}
