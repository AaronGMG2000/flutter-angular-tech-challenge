import 'package:catalog/core/theme/index.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';

class InCartPill extends StatelessWidget {
  const InCartPill({required this.quantity, super.key});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      label: AppLang.of(context).inCart(quantity),
      excludeSemantics: true,
      child: Container(
        height: AppSizes.badgeMinSize,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inCartHorizontal,
        ),
        decoration: ShapeDecoration(
          color: colors.accent,
          shape: const StadiumBorder(),
          shadows: AppShadows.card(colors.shadow),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.inCartGap,
          children: [
            Icon(
              Icons.shopping_cart,
              size: AppSizes.inCartIcon,
              color: colors.onAccent,
            ),
            Text(
              '$quantity',
              style: AppTextStyles.badge.copyWith(color: colors.onAccent),
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class InCartShape {
  static ShapeBorder? of(BuildContext context, {required bool inCart}) {
    if (!inCart) return null;
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
      side: BorderSide(color: context.colors.accent, width: AppBorders.focus),
    );
  }
}
