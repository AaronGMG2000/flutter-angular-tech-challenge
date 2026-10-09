import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/features/cart/presentation/widgets/added_to_cart_snack_bar.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/presentation/widgets/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        return Consumer(
          builder: (context, ref, child) => ProductListTile(
            product: product,
            cartQuantity: ref.watch(
              cartProvider.select((cart) => cart.quantityOf(product.id)),
            ),
            onTap: () => context.push(AppRoutes.product(product.id)),
            onAdd: () {
              ref.read(cartProvider.notifier).add(product);
              showAddedToCartSnackBar(context);
            },
          ),
        );
      },
    );
  }
}
