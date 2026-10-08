import 'package:catalog/core/constants/api_constants.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_list_provider.g.dart';

@riverpod
class ProductList extends _$ProductList {
  @override
  Future<ProductPage> build() {
    final repository = ref.watch(productRepositoryProvider);
    return repository.getProducts(skip: 0, limit: ApiConstants.pageSize);
  }
}
