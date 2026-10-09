import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartBadge extends ConsumerWidget {
  const CartBadge({required this.borderColor, super.key});

  final Color borderColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartProvider.select((cart) => cart.totalItems));
    final colors = context.colors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppShadows.card(colors.shadow),
          ),
          child: IconButton(
            tooltip: AppLang.of(context).cartTitle,
            onPressed: () => context.push(AppRoutes.cart),
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
        if (count > 0)
          Positioned(
            top: AppSpacing.badgeOffset,
            right: AppSpacing.badgeOffset,
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
