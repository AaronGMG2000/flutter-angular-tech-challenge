import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const display = 'AlumniSans';
  static const body = 'Inter';
}

abstract final class AppTextStyles {
  static const double _bodyTrackingEm = -0.01;
  static const double _displayTracking = -0.5;

  static TextStyle _display(double size) => TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w800,
    fontSize: size,
    height: 1,
    letterSpacing: _displayTracking,
  );

  static TextStyle _body(double size, FontWeight weight, {double? height}) =>
      TextStyle(
        fontFamily: AppFonts.body,
        fontWeight: weight,
        fontSize: size,
        height: height,
        letterSpacing: size * _bodyTrackingEm,
      );

  static final appBarTitle = _display(32);
  static final cartLineTotal = _display(20);
  static final priceSmall = _display(22);
  static final priceLarge = _display(48);
  static final cartTotal = _display(56);

  static final productCardTitle = _body(13, FontWeight.w600);
  static final caption = _body(13, FontWeight.w400);
  static final badge = _body(11, FontWeight.w700);
  static final discount = _body(13, FontWeight.w600);

  static final textTheme = TextTheme(
    headlineSmall: _body(24, FontWeight.w600),
    titleLarge: _body(20, FontWeight.w600),
    titleMedium: _body(16, FontWeight.w600),
    titleSmall: _body(14, FontWeight.w600),
    bodyLarge: _body(15, FontWeight.w400),
    bodyMedium: _body(14, FontWeight.w400, height: 1.45),
    bodySmall: _body(12, FontWeight.w400),
    labelLarge: _body(15, FontWeight.w500),
    labelMedium: _body(14, FontWeight.w500),
    labelSmall: _body(12, FontWeight.w500),
  );
}
