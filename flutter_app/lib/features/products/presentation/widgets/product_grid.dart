import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/presentation/widgets/load_more_indicator.dart';
import 'package:catalog/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const double _loadMoreThreshold = 200;

class ProductGrid extends StatelessWidget {
  final ProductPage page;
  final VoidCallback onLoadMore;

  const ProductGrid({required this.page, required this.onLoadMore, super.key});

  bool _handleScroll(ScrollNotification notification) {
    if (page.hasMore && notification.metrics.extentAfter < _loadMoreThreshold) {
      onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final products = page.items;

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppLayout.gridColumns,
                    mainAxisSpacing: AppSpacing.gridGap,
                    crossAxisSpacing: AppSpacing.gridGap,
                    mainAxisExtent: AppSizes.productCardHeight,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Consumer(
                      builder: (context, ref, child) => ProductCard(
                        product: product,
                        cartQuantity: ref.watch(
                          cartProvider.select(
                            (cart) => cart.quantityOf(product.id),
                          ),
                        ),
                        onTap: () =>
                            context.push(AppRoutes.product(product.id)),
                      ),
                    );
                  },
                ),
                if (page.hasMore)
                  SliverToBoxAdapter(
                    child: LoadMoreIndicator(
                      loaded: products.length,
                      total: page.total,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
