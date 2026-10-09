import 'dart:convert';
import 'dart:typed_data';

import 'package:catalog/features/products/data/datasources/product_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.body);

  final Object? body;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, Object> _productJson(int id) => {
  'id': id,
  'title': 'Product $id',
  'description': 'Description',
  'category': 'beauty',
  'price': 9.99,
  'discountPercentage': 7.17,
  'rating': 4.94,
  'stock': 5,
  'thumbnail': 'https://cdn.dummyjson.com/$id.png',
};

void main() {
  late _FakeAdapter adapter;

  ProductRemoteDataSource dataSource(Object? body) {
    adapter = _FakeAdapter(body);
    final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'))
      ..httpClientAdapter = adapter;
    return ProductRemoteDataSource(dio);
  }

  final page = {
    'products': [_productJson(1)],
    'total': 194,
    'skip': 20,
    'limit': 20,
  };

  test('fetchProducts sends skip and limit', () async {
    final response = await dataSource(page).fetchProducts(skip: 20, limit: 20);

    final request = adapter.requests.single;
    expect(request.path, '/products');
    expect(request.queryParameters, {'skip': 20, 'limit': 20});
    expect(response.total, 194);
    expect(response.products.single.title, 'Product 1');
  });

  test('searchProducts sends the query', () async {
    await dataSource(page).searchProducts('phone', skip: 0, limit: 0);

    final request = adapter.requests.single;
    expect(request.path, '/products/search');
    expect(request.queryParameters, {'q': 'phone', 'skip': 0, 'limit': 0});
  });

  test('fetchProductsByCategory puts the slug in the path', () async {
    await dataSource(page)
        .fetchProductsByCategory('smartphones', skip: 0, limit: 20);

    expect(adapter.requests.single.path, '/products/category/smartphones');
  });

  test('fetchProductById and fetchCategories parse their bodies', () async {
    final product = await dataSource(_productJson(7)).fetchProductById(7);
    expect(adapter.requests.single.path, '/products/7');
    expect(product.id, 7);

    final categories = await dataSource([
      {'slug': 'beauty', 'name': 'Beauty', 'url': 'https://dummyjson.com'},
    ]).fetchCategories();
    expect(categories.single.slug, 'beauty');
  });

  test('empty body becomes a FormatException', () async {
    await expectLater(
      dataSource(null).fetchProductById(1),
      throwsA(isA<FormatException>()),
    );
  });
}
