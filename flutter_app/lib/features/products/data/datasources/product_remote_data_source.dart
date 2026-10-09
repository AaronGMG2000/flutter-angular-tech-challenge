import 'package:catalog/core/network/dio_provider.dart';
import 'package:catalog/features/products/data/models/product_category_dto.dart';
import 'package:catalog/features/products/data/models/product_dto.dart';
import 'package:catalog/features/products/data/models/products_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_remote_data_source.g.dart';

class ProductRemoteDataSource {
  const ProductRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ProductsResponseDto> fetchProducts({
    required int skip,
    required int limit,
  }) {
    return _fetchPage('/products', skip: skip, limit: limit);
  }

  Future<ProductsResponseDto> searchProducts(
    String query, {
    required int skip,
    required int limit,
  }) {
    return _fetchPage(
      '/products/search',
      skip: skip,
      limit: limit,
      extraParams: {'q': query},
    );
  }

  Future<ProductsResponseDto> fetchProductsByCategory(
    String slug, {
    required int skip,
    required int limit,
  }) {
    return _fetchPage('/products/category/$slug', skip: skip, limit: limit);
  }

  Future<ProductDto> fetchProductById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/products/$id');
    return ProductDto.fromJson(_requireData(response));
  }

  Future<List<ProductCategoryDto>> fetchCategories() async {
    final response = await _dio.get<List<dynamic>>('/products/categories');
    return _requireData(response)
        .cast<Map<String, dynamic>>()
        .map(ProductCategoryDto.fromJson)
        .toList();
  }

  Future<ProductsResponseDto> _fetchPage(
    String path, {
    required int skip,
    required int limit,
    Map<String, Object> extraParams = const {},
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: {...extraParams, 'skip': skip, 'limit': limit},
    );
    return ProductsResponseDto.fromJson(_requireData(response));
  }

  T _requireData<T>(Response<T> response) {
    final data = response.data;
    if (data == null) throw const FormatException('Empty response body');
    return data;
  }
}

@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  return ProductRemoteDataSource(ref.watch(dioProvider));
}
