import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/products/presentation/providers/product_list_provider.dart';
import 'package:catalog/features/products/presentation/widgets/product_grid.dart';
import 'package:catalog/features/products/presentation/widgets/product_grid_skeleton.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:catalog/shared/widgets/state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = AppLang.of(context);
    final colors = context.colors;
    final products = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.appTitle),
        titleSpacing: AppSpacing.appBarStart,
      ),
      body: products.when(
        skipLoadingOnRefresh: false,
        loading: () => const ProductGridSkeleton(),
        error: (error, stackTrace) => StateView(
          icon: Icons.wifi_off,
          circleColor: colors.errorSurface,
          iconColor: colors.errorIcon,
          title: lang.productsErrorTitle,
          message: lang.productsErrorMessage,
          action: FilledButton.icon(
            style: StateView.actionStyle,
            onPressed: () => ref.invalidate(productListProvider),
            icon: const Icon(Icons.refresh),
            label: Text(lang.retry),
          ),
        ),
        data: (page) => page.items.isEmpty
            ? StateView(
                icon: Icons.inventory_2_outlined,
                circleColor: colors.emptySurface,
                iconColor: colors.onAccent,
                title: lang.emptyTitle,
              )
            : ProductGrid(
                page: page,
                onLoadMore: () =>
                    ref.read(productListProvider.notifier).loadMore(),
              ),
      ),
    );
  }
}
