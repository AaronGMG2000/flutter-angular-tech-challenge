import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/products/presentation/providers/category_providers.dart';
import 'package:catalog/features/products/presentation/providers/product_list_provider.dart';
import 'package:catalog/features/products/presentation/providers/search_query_provider.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchStatusText extends ConsumerWidget {
  const SearchStatusText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    if (query.isEmpty) return const SizedBox.shrink();

    final lang = AppLang.of(context);
    final category = ref.watch(selectedCategoryProvider);
    final products = ref.watch(productListProvider);

    final text = switch (products) {
      AsyncValue(isLoading: true) when category != null => lang.searchingIn(
        query,
        category.name,
      ),
      AsyncValue(isLoading: true) => lang.searching(query),
      AsyncData(:final value) when value.total > 0 => lang.searchResultsCount(
        value.total,
        query,
      ),
      _ => null,
    };
    if (text == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.headerGap,
        AppSpacing.screenHorizontal,
        0,
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
