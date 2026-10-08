import 'package:catalog/core/error/guard_request.dart';
import 'package:catalog/features/products/data/datasources/product_remote_data_source.dart';
import 'package:catalog/features/products/data/models/product_category_dto.dart';
import 'package:catalog/features/products/data/models/product_dto.dart';
import 'package:catalog/features/products/data/models/products_response_dto.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/domain/entities/product_category.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/domain/repositories/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repository_impl.g.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remote);

  final ProductRemoteDataSource _remote;

  @override
  Future<ProductPage> getProducts({required int skip, required int limit}) {
    return guardRequest(() async {
      final dto = await _remote.fetchProducts(skip: skip, limit: limit);
      return dto.toEntity();
    });
  }

  @override
  Future<ProductPage> searchProducts(
    String query, {
    required int skip,
    required int limit,
  }) {
    return guardRequest(() async {
      final dto = await _remote.searchProducts(query, skip: skip, limit: limit);
      return dto.toEntity();
    });
  }

  @override
  Future<ProductPage> getProductsByCategory(
    String slug, {
    required int skip,
    required int limit,
  }) {
    return guardRequest(() async {
      final dto = await _remote.fetchProductsByCategory(
        slug,
        skip: skip,
        limit: limit,
      );
      return dto.toEntity();
    });
  }

  @override
  Future<Product> getProductById(int id) {
    return guardRequest(() async {
      final dto = await _remote.fetchProductById(id);
      return dto.toEntity();
    });
  }

  @override
  Future<List<ProductCategory>> getCategories() {
    return guardRequest(() async {
      final dtos = await _remote.fetchCategories();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }
}

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider));
}
