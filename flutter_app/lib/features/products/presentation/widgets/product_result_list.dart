import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/presentation/widgets/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductResultList extends StatelessWidget {
  const ProductResultList({required this.products, super.key});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      itemCount: products.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.listGap),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListTile(
          product: product,
          onTap: () => context.push(AppRoutes.product(product.id)),
        );
      },
    );
  }
}
