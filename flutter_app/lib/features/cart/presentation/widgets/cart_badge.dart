import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/core/utils/app_formats.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartBadge extends ConsumerWidget {
  const CartBadge({
    required this.borderColor,
    this.opensCart = true,
    super.key,
  });

  final Color borderColor;
  final bool opensCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartProvider.select((cart) => cart.totalItems));
    final total = ref.watch(cartProvider.select((cart) => cart.total));
    final lang = AppLang.of(context);
    final colors = context.colors;
    final hasItems = count > 0;

    return Semantics(
      button: opensCart,
      label: hasItems
          ? lang.cartBadgeLabel(count, AppFormats.price(total))
          : lang.cartTitle,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          shadows: AppShadows.card(colors.shadow),
        ),
        child: Material(
          color: colors.surface,
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: opensCart ? () => context.push(AppRoutes.cart) : null,
            child: SizedBox(
              height: AppSizes.tapTarget,
              child: Padding(
                padding: hasItems
                    ? const EdgeInsets.only(
                        left: AppSpacing.cartButtonStart,
                        right: AppSpacing.cartButtonEnd,
                      )
                    : EdgeInsets.zero,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.cartButtonGap,
                  children: [
                    SizedBox(
                      width: hasItems ? null : AppSizes.tapTarget,
                      child: _CartIcon(count: count, borderColor: borderColor),
                    ),
                    if (hasItems)
                      Text(
                        AppFormats.price(total),
                        style: AppTextStyles.cartLineTotal.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count, required this.borderColor});

  final int count;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Icon(
          Icons.shopping_cart,
          size: AppSizes.appBarIcon,
          color: context.colors.textPrimary,
        ),
        if (count > 0)
          Positioned(
            top: AppSpacing.cartCountTop,
            right: AppSpacing.cartCountEnd,
            child: _BadgeCount(count: count, borderColor: borderColor),
          ),
      ],
    );
  }
}

class _BadgeCount extends StatelessWidget {
  const _BadgeCount({required this.count, required this.borderColor});

  final int count;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(
        minWidth: AppSizes.badgeMinSize,
        minHeight: AppSizes.badgeMinSize,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.badgeHorizontal,
      ),
      decoration: ShapeDecoration(
        color: colors.accent,
        shape: StadiumBorder(
          side: BorderSide(color: borderColor, width: AppBorders.badge),
        ),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          '$count',
          style: AppTextStyles.badge.copyWith(color: colors.onAccent),
        ),
      ),
    );
  }
}
