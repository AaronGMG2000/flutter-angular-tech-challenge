import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_providers.g.dart';

@riverpod
Future<List<ProductCategory>> categories(Ref ref) {
  return ref.watch(productRepositoryProvider).getCategories();
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  ProductCategory? build() => null;

  void toggle(ProductCategory category) {
    state = state == category ? null : category;
  }

  void clear() => state = null;
}
