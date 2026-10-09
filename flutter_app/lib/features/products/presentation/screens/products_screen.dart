import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/widgets/cart_badge.dart';
import 'package:catalog/features/products/presentation/providers/category_providers.dart';
import 'package:catalog/features/products/presentation/providers/product_list_provider.dart';
import 'package:catalog/features/products/presentation/providers/search_query_provider.dart';
import 'package:catalog/features/products/presentation/widgets/category_chips.dart';
import 'package:catalog/features/products/presentation/widgets/product_grid.dart';
import 'package:catalog/features/products/presentation/widgets/product_grid_skeleton.dart';
import 'package:catalog/features/products/presentation/widgets/product_list_skeleton.dart';
import 'package:catalog/features/products/presentation/widgets/product_result_list.dart';
import 'package:catalog/features/products/presentation/widgets/search_field.dart';
import 'package:catalog/features/products/presentation/widgets/search_status_text.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:catalog/shared/widgets/state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLang.of(context).appTitle),
        titleSpacing: AppSpacing.appBarStart,
        actionsPadding: const EdgeInsets.only(right: AppSpacing.appBarEnd),
        actions: [CartBadge(borderColor: context.colors.background)],
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.headerTop,
              AppSpacing.screenHorizontal,
              AppSpacing.headerGap,
            ),
            child: SearchField(),
          ),
          CategoryChips(),
          SearchStatusText(),
          Expanded(child: ProductsBody()),
        ],
      ),
    );
  }
}

class ProductsBody extends ConsumerWidget {
  const ProductsBody({super.key});

  void _clearFilters(WidgetRef ref) {
    ref.read(searchQueryProvider.notifier).clear();
    ref.read(selectedCategoryProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = AppLang.of(context);
    final colors = context.colors;
    final query = ref.watch(searchQueryProvider);
    final products = ref.watch(productListProvider);

    return products.when(
      skipLoadingOnRefresh: false,
      loading: () => query.isEmpty
          ? const ProductGridSkeleton()
          : const ProductListSkeleton(),
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
      data: (page) {
        if (page.items.isEmpty) {
          return StateView(
            icon: Icons.inventory_2_outlined,
            circleColor: colors.emptySurface,
            iconColor: colors.onAccent,
            title: lang.emptyTitle,
            message: query.isEmpty ? null : lang.emptyMessage(query),
            action: OutlinedButton(
              style: StateView.actionStyle,
              onPressed: () => _clearFilters(ref),
              child: Text(lang.clearSearch),
            ),
          );
        }
        if (query.isNotEmpty) return ProductResultList(products: page.items);
        return ProductGrid(
          page: page,
          onLoadMore: () => ref.read(productListProvider.notifier).loadMore(),
        );
      },
    );
  }
}
