import 'package:catalog/features/products/data/models/product_dto.dart';
import 'package:catalog/features/products/data/models/products_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final productJson = <String, dynamic>{
    'id': 1,
    'title': 'Essence Mascara Lash Princess',
    'description': 'Popular mascara',
    'category': 'beauty',
    'price': 9.99,
    'discountPercentage': 7.17,
    'rating': 4.94,
    'stock': 5,
    'brand': 'Essence',
    'thumbnail': 'https://cdn.dummyjson.com/thumbnail.png',
    'images': ['https://cdn.dummyjson.com/1.png'],
  };

  group('ProductDto.fromJson', () {
    test('parses DummyJSON product into entity', () {
      final product = ProductDto.fromJson(productJson).toEntity();

      expect(product.id, 1);
      expect(product.price, 9.99);
      expect(product.brand, 'Essence');
      expect(product.images, hasLength(1));
    });

    test('accepts integer price and missing brand', () {
      final json = {...productJson, 'price': 10}..remove('brand');

      final product = ProductDto.fromJson(json).toEntity();

      expect(product.price, 10.0);
      expect(product.brand, isNull);
    });
  });

  group('ProductsResponseDto.toEntity', () {
    test('exposes hasMore while skip plus items is below total', () {
      final page = ProductsResponseDto.fromJson({
        'products': [productJson],
        'total': 194,
        'skip': 0,
        'limit': 20,
      }).toEntity();

      expect(page.items, hasLength(1));
      expect(page.hasMore, isTrue);
    });

    test('hasMore is false on last page', () {
      final page = ProductsResponseDto.fromJson({
        'products': [productJson],
        'total': 21,
        'skip': 20,
        'limit': 20,
      }).toEntity();

      expect(page.hasMore, isFalse);
    });
  });
}
