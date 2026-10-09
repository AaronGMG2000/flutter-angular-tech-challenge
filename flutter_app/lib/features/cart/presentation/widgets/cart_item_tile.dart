import 'package:catalog/core/theme/index.dart';
import 'package:catalog/core/utils/app_formats.dart';
import 'package:catalog/features/cart/domain/entities/cart_item.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/features/products/presentation/widgets/product_list_tile.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:catalog/shared/widgets/quantity_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItemTile extends ConsumerWidget {
  const CartItemTile({required this.item, super.key});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.read(cartProvider.notifier);
    final colors = context.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.tilePadding),
        child: Row(
          spacing: AppSpacing.tileGap,
          children: [
            ProductThumbnail(
              url: item.thumbnail,
              size: AppSizes.cartTileThumbnail,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        tooltip: AppLang.of(context).removeFromCart,
                        onPressed: () => cart.remove(item.productId),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: colors.textTertiary,
                        ),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppFormats.price(item.subtotal),
                        style: AppTextStyles.cartLineTotal,
                      ),
                      QuantityStepper(
                        compact: true,
                        quantity: item.quantity,
                        onDecrement: () => cart.updateQuantity(
                          item.productId,
                          item.quantity - 1,
                        ),
                        onIncrement: () => cart.updateQuantity(
                          item.productId,
                          item.quantity + 1,
                        ),
                      ),
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
