import 'package:catalog/core/theme/index.dart';
import 'package:catalog/core/theme/theme_mode_provider.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;

    return IconButton(
      tooltip: AppLang.of(context).toggleTheme,
      onPressed: ref.read(themeModeProvider.notifier).toggle,
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? colors.accent : colors.textPrimary,
        iconSize: AppSizes.themeIcon,
      ),
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
    );
  }
}
