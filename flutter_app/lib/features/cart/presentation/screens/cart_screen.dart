import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:catalog/features/cart/presentation/widgets/cart_summary.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:catalog/shared/widgets/state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final lang = AppLang.of(context);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.cartTitle),
        actionsPadding: const EdgeInsets.only(right: AppSpacing.appBarEnd),
        actions: [
          if (!cart.isEmpty)
            Text(
              lang.cartUnits(cart.totalItems),
              style: AppTextStyles.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
        ],
      ),
      body: cart.isEmpty
          ? StateView(
              icon: Icons.shopping_cart_outlined,
              circleColor: colors.emptySurface,
              iconColor: colors.onAccent,
              title: lang.cartEmpty,
              message: lang.cartEmptyMessage,
              action: FilledButton(
                style: StateView.actionStyle,
                onPressed: () => context.go(AppRoutes.products),
                child: Text(lang.goToCatalog),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.headerTop,
                      AppSpacing.screenHorizontal,
                      0,
                    ),
                    itemCount: cart.items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.listGap),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return CartItemTile(
                        key: ValueKey(item.productId),
                        item: item,
                      );
                    },
                  ),
                ),
                const CartSummary(),
              ],
            ),
    );
  }
}
