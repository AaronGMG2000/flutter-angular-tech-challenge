import 'package:catalog/core/theme/index.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.compact = false,
    super.key,
  });

  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final lang = AppLang.of(context);
    final buttonSize = compact
        ? AppSizes.stepperCompactHeight
        : AppSizes.tapTarget;

    return Container(
      height: compact
          ? AppSizes.stepperCompactHeight
          : AppSizes.buttonLargeHeight,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 0 : AppSpacing.stepperPadding,
      ),
      decoration: ShapeDecoration(
        color: compact ? colors.background : null,
        shape: StadiumBorder(
          side: compact
              ? BorderSide.none
              : BorderSide(color: colors.borderDefault),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            tooltip: lang.decrease,
            size: buttonSize,
            compact: compact,
            onPressed: onDecrement,
          ),
          SizedBox(
            width: compact
                ? AppSizes.stepperCompactValueWidth
                : AppSizes.stepperValueWidth,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: compact
                  ? AppTextStyles.quantityCompact
                  : Theme.of(context).textTheme.titleSmall,
            ),
          ),
          _StepButton(
            icon: Icons.add,
            tooltip: lang.increase,
            size: buttonSize,
            compact: compact,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.size,
    required this.compact,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final double size;
  final bool compact;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        fixedSize: Size.square(size),
        minimumSize: Size.square(size),
        padding: EdgeInsets.zero,
        iconSize: compact ? AppSizes.stepperCompactIcon : AppSizes.appBarIcon,
      ),
    );
  }
}
