import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_colors.g.theme.dart';

@ThemeExtensions(contextAccessorName: 'colors')
class AppColors extends ThemeExtension<AppColors> with _$AppColors {
  const AppColors({
    required this.background,
    required this.surface,
    required this.imageSurface,
    required this.skeleton,
    required this.borderSubtle,
    required this.borderDefault,
    required this.focus,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconSecondary,
    required this.link,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.onAccent,
    required this.rating,
    required this.cartSummary,
    required this.onCartSummary,
    required this.categoryTagSurface,
    required this.categoryTagText,
    required this.successSurface,
    required this.successText,
    required this.discountSurface,
    required this.discountText,
    required this.errorSurface,
    required this.errorIcon,
    required this.emptySurface,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color imageSurface;
  final Color skeleton;
  final Color borderSubtle;
  final Color borderDefault;
  final Color focus;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color iconSecondary;
  final Color link;
  final Color primary;
  final Color onPrimary;
  final Color accent;
  final Color onAccent;
  final Color rating;
  final Color cartSummary;
  final Color onCartSummary;
  final Color categoryTagSurface;
  final Color categoryTagText;
  final Color successSurface;
  final Color successText;
  final Color discountSurface;
  final Color discountText;
  final Color errorSurface;
  final Color errorIcon;
  final Color emptySurface;
  final Color shadow;

  static const light = AppColors(
    background: Color(0xFFF7F5EB),
    surface: Color(0xFFFFFFFF),
    imageSurface: Color(0xFFF5F2E5),
    skeleton: Color(0xFFEBE9E1),
    borderSubtle: Color(0xFFEBE9E1),
    borderDefault: Color(0xFFD4D2CB),
    focus: Color(0xFF00E5D4),
    textPrimary: Color(0xFF042914),
    textSecondary: Color(0xFF504E49),
    textTertiary: Color(0xFF929087),
    iconSecondary: Color(0xFF737168),
    link: Color(0xFF008379),
    primary: Color(0xFF042914),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFE8FB10),
    onAccent: Color(0xFF042914),
    rating: Color(0xFFEC8D00),
    cartSummary: Color(0xFF042914),
    onCartSummary: Color(0xFFFFFFFF),
    categoryTagSurface: Color(0xFFE6FBF9),
    categoryTagText: Color(0xFF4A5D50),
    successSurface: Color(0xFFF0FAF5),
    successText: Color(0xFF034F24),
    discountSurface: Color(0xFFFBF0F0),
    discountText: Color(0xFFA20303),
    errorSurface: Color(0xFFFBE2E2),
    errorIcon: Color(0xFFD40404),
    emptySurface: Color(0xFFE7DEBD),
    shadow: Color(0x0A042914),
  );

  static const dark = AppColors(
    background: Color(0xFF0F1C14),
    surface: Color(0xFF123726),
    imageSurface: Color(0xFFE7DEBD),
    skeleton: Color(0xFF253829),
    borderSubtle: Color(0xFF253829),
    borderDefault: Color(0xFF374A3E),
    focus: Color(0xFF00E5D4),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFC9D6CE),
    textTertiary: Color(0xFF8AA396),
    iconSecondary: Color(0xFF8AA396),
    link: Color(0xFF5FFFF3),
    primary: Color(0xFF5FFFF3),
    onPrimary: Color(0xFF042914),
    accent: Color(0xFFE8FB10),
    onAccent: Color(0xFF042914),
    rating: Color(0xFFFFBC59),
    cartSummary: Color(0xFF253829),
    onCartSummary: Color(0xFFFFFFFF),
    categoryTagSurface: Color(0xFF253829),
    categoryTagText: Color(0xFFC9D6CE),
    successSurface: Color(0xFF253829),
    successText: Color(0xFF4FF798),
    discountSurface: Color(0xFF310202),
    discountText: Color(0xFFFEBDBD),
    errorSurface: Color(0xFF310202),
    errorIcon: Color(0xFFFD8A8A),
    emptySurface: Color(0xFFE7DEBD),
    shadow: Color(0x0A000000),
  );
}
