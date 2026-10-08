import 'package:flutter/material.dart';
import 'package:catalog/core/theme/app_colors.dart';
import 'package:catalog/core/theme/app_dimens.dart';
import 'package:catalog/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: colors.primary,
          brightness: brightness,
        ).copyWith(
          primary: colors.primary,
          onPrimary: colors.onPrimary,
          surface: colors.surface,
          onSurface: colors.textPrimary,
          onSurfaceVariant: colors.textSecondary,
          outline: colors.borderDefault,
          outlineVariant: colors.borderSubtle,
          error: colors.errorIcon,
        );

    final textTheme = AppTextStyles.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );

    const pillShape = StadiumBorder();

    return ThemeData(
      colorScheme: scheme,
      fontFamily: AppFonts.body,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.background,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: AppSizes.appBarHeight,
        centerTitle: false,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(
          color: colors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: colors.borderSubtle),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: textTheme.bodyLarge?.copyWith(color: colors.textTertiary),
        prefixIconColor: colors.textTertiary,
        suffixIconColor: colors.textTertiary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        constraints: const BoxConstraints(minHeight: AppSizes.searchHeight),
        enabledBorder: _pillBorder(colors.borderDefault),
        focusedBorder: _pillBorder(colors.focus, width: AppBorders.focus),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.primary,
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: colors.onPrimary,
        ),
        side: BorderSide(color: colors.borderSubtle),
        shape: pillShape,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.chipHorizontal,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          textStyle: textTheme.labelLarge,
          shape: pillShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: colors.borderDefault),
          shape: pillShape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          fixedSize: const Size.square(AppSizes.tapTarget),
          iconSize: AppSizes.appBarIcon,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.link),
      dividerTheme: DividerThemeData(color: colors.borderSubtle, space: 1),
    );
  }

  static OutlineInputBorder _pillBorder(
    Color color, {
    double width = AppBorders.thin,
  }) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.pill),
    borderSide: BorderSide(color: color, width: width),
  );
}
