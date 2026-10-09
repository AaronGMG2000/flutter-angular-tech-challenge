import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/features/cart/presentation/widgets/added_to_cart_snack_bar.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/presentation/providers/detail_quantity_provider.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:catalog/shared/widgets/quantity_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailBottomBar extends ConsumerWidget {
  const DetailBottomBar({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final quantityProvider = detailQuantityProvider(product.id);
    final quantity = ref.watch(quantityProvider);
    final notifier = ref.read(quantityProvider.notifier);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.borderSubtle)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          AppSpacing.bottomBarTop,
          AppSpacing.screenHorizontal,
          AppSpacing.bottomBarBottom,
        ),
        child: Row(
          spacing: AppSpacing.tileGap,
          children: [
            QuantityStepper(
              quantity: quantity,
              onDecrement: quantity > 1 ? notifier.decrement : null,
              onIncrement: notifier.increment,
            ),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                    AppSizes.buttonLargeHeight,
                  ),
                ),
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .add(product, quantity: quantity);
                  showAddedToCartSnackBar(context);
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(AppLang.of(context).addToCart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
