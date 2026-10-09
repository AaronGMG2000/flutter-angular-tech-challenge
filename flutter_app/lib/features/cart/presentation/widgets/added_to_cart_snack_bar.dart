import 'package:catalog/core/theme/index.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';

void showAddedToCartSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: AppDurations.toast,
        content: Text(AppLang.of(context).addedToCart),
      ),
    );
}
