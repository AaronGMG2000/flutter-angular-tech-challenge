import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/domain/entities/product_category.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';

abstract interface class ProductRepository {
  Future<ProductPage> getProducts({required int skip, required int limit});

  Future<ProductPage> searchProducts(
    String query, {
    required int skip,
    required int limit,
  });

  Future<ProductPage> getProductsByCategory(
    String slug, {
    required int skip,
    required int limit,
  });

  Future<Product> getProductById(int id);

  Future<List<ProductCategory>> getCategories();
}
