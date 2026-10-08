import 'package:flutter/material.dart';
import 'package:catalog/l10n/app_lang.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLang.of(context).appTitle)),
    );
  }
}
