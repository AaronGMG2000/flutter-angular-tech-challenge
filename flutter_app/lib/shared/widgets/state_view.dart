import 'package:catalog/core/theme/index.dart';
import 'package:flutter/material.dart';

class StateView extends StatelessWidget {
  final IconData icon;
  final Color circleColor;
  final Color iconColor;
  final String title;
  final String? message;
  final Widget? action;

  const StateView({
    required this.icon,
    required this.circleColor,
    required this.iconColor,
    required this.title,
    this.message,
    this.action,
    super.key,
  });

  static const ButtonStyle actionStyle = ButtonStyle(
    minimumSize: WidgetStatePropertyAll(Size(0, AppSizes.buttonHeight)),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: AppSpacing.stateActionHorizontal),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final message = this.message;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.statePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.stateGap,
          children: [
            Container(
              width: AppSizes.stateIconCircle,
              height: AppSizes.stateIconCircle,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppSizes.stateIcon, color: iconColor),
            ),
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null)
              Text(
                message,
                style: textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ?action,
          ],
        ),
      ),
    );
  }
}
