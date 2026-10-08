import 'package:catalog/core/constants/api_constants.dart';
import 'package:catalog/core/error/failure.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_list_provider.g.dart';

@riverpod
class ProductList extends _$ProductList {
  bool _isLoadingMore = false;

  @override
  Future<ProductPage> build() {
    final repository = ref.watch(productRepositoryProvider);
    return repository.getProducts(skip: 0, limit: ApiConstants.pageSize);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    try {
      final next = await ref
          .read(productRepositoryProvider)
          .getProducts(
            skip: current.items.length,
            limit: ApiConstants.pageSize,
          );
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          total: next.total,
        ),
      );
    } on Failure {
      return;
    } finally {
      _isLoadingMore = false;
    }
  }
}
