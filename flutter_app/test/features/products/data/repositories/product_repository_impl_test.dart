import 'package:catalog/core/error/failure.dart';
import 'package:catalog/features/products/data/datasources/product_remote_data_source.dart';
import 'package:catalog/features/products/data/models/product_dto.dart';
import 'package:catalog/features/products/data/models/products_response_dto.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

void main() {
  late _MockRemoteDataSource remote;
  late ProductRepositoryImpl repository;

  const productDto = ProductDto(
    id: 1,
    title: 'Mascara',
    description: 'Popular mascara',
    category: 'beauty',
    price: 9.99,
    discountPercentage: 7.17,
    rating: 4.94,
    stock: 5,
    thumbnail: 'https://cdn.dummyjson.com/thumbnail.png',
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = ProductRepositoryImpl(remote);
  });

  test('getProducts maps response to ProductPage', () async {
    when(() => remote.fetchProducts(skip: 0, limit: 20)).thenAnswer(
      (_) async => const ProductsResponseDto(
        products: [productDto],
        total: 194,
        skip: 0,
        limit: 20,
      ),
    );

    final page = await repository.getProducts(skip: 0, limit: 20);

    expect(page.items.single.title, 'Mascara');
    expect(page.total, 194);
  });

  test('getProductById converts 404 into NotFoundFailure', () async {
    final requestOptions = RequestOptions(path: '/products/999');
    when(() => remote.fetchProductById(999)).thenThrow(
      DioException.badResponse(
        statusCode: 404,
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 404),
      ),
    );

    await expectLater(
      () => repository.getProductById(999),
      throwsA(isA<NotFoundFailure>()),
    );
  });

  test('malformed payload becomes ParseFailure', () async {
    when(
      () => remote.fetchProductById(1),
    ).thenAnswer((_) async => ProductDto.fromJson({'id': '1'}));

    await expectLater(
      () => repository.getProductById(1),
      throwsA(isA<ParseFailure>()),
    );
  });
}
