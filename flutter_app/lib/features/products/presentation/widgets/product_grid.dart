import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({required this.products, super.key});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.gridGap,
        crossAxisSpacing: AppSpacing.gridGap,
        mainAxisExtent: AppSizes.productCardHeight,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}
