import 'package:catalog/core/constants/api_constants.dart';
import 'package:catalog/core/error/failure.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/domain/repositories/product_repository.dart';
import 'package:catalog/features/products/presentation/providers/category_providers.dart';
import 'package:catalog/features/products/presentation/providers/search_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_list_provider.g.dart';

@riverpod
class ProductList extends _$ProductList {
  bool _isLoadingMore = false;

  @override
  Future<ProductPage> build() async {
    final repository = ref.watch(productRepositoryProvider);
    final query = ref.watch(searchQueryProvider);
    final category = ref.watch(selectedCategoryProvider)?.slug;

    if (query.isNotEmpty) {
      var cancelled = false;
      ref.onDispose(() => cancelled = true);
      await Future<void>.delayed(ApiConstants.searchDebounce);
      if (cancelled) throw const CancelledFailure();
    }

    return switch ((query, category)) {
      ('', null) => repository.getProducts(
        skip: 0,
        limit: ApiConstants.pageSize,
      ),
      ('', final slug?) => repository.getProductsByCategory(
        slug,
        skip: 0,
        limit: ApiConstants.pageSize,
      ),
      (_, null) => repository.searchProducts(
        query,
        skip: 0,
        limit: ApiConstants.allResults,
      ),
      (_, final slug?) => _searchInCategory(repository, query, slug),
    };
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || _isLoadingMore) return;

    final repository = ref.read(productRepositoryProvider);
    final category = ref.read(selectedCategoryProvider)?.slug;
    final skip = current.items.length;

    var stale = false;
    final removeListener = ref.onDispose(() => stale = true);
    _isLoadingMore = true;
    try {
      final next = category == null
          ? await repository.getProducts(
              skip: skip,
              limit: ApiConstants.pageSize,
            )
          : await repository.getProductsByCategory(
              category,
              skip: skip,
              limit: ApiConstants.pageSize,
            );
      if (stale) return;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          total: next.total,
        ),
      );
    } on Failure {
      return;
    } finally {
      removeListener();
      _isLoadingMore = false;
    }
  }

  Future<ProductPage> _searchInCategory(
    ProductRepository repository,
    String query,
    String category,
  ) async {
    final page = await repository.searchProducts(
      query,
      skip: 0,
      limit: ApiConstants.allResults,
    );
    final items = page.items
        .where((product) => product.category == category)
        .toList();
    return page.copyWith(items: items, total: items.length, skip: 0);
  }
}
