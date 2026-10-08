import 'dart:async';

import 'package:catalog/core/error/failure.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/domain/entities/product_category.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/domain/repositories/product_repository.dart';
import 'package:catalog/features/products/presentation/providers/category_providers.dart';
import 'package:catalog/features/products/presentation/providers/product_list_provider.dart';
import 'package:catalog/features/products/presentation/providers/search_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProductRepository extends Mock implements ProductRepository {}

Product _product(int id) => Product(
  id: id,
  title: 'Product $id',
  description: 'Description $id',
  category: 'beauty',
  price: 9.99,
  discountPercentage: 0,
  rating: 4.5,
  stock: 1,
  thumbnail: 'https://cdn.dummyjson.com/$id.png',
  images: const [],
);

ProductPage _page({required int skip, required int count, int total = 40}) {
  return ProductPage(
    items: List.generate(count, (index) => _product(skip + index + 1)),
    total: total,
    skip: skip,
    limit: 20,
  );
}

void main() {
  late _MockProductRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockProductRepository();
    container = ProviderContainer.test(
      overrides: [productRepositoryProvider.overrideWithValue(repository)],
      retry: (retryCount, error) => null,
    );
  });

  void stubPage(int skip, Future<ProductPage> Function() answer) {
    when(() => repository.getProducts(skip: skip, limit: 20))
        .thenAnswer((_) => answer());
  }

  test('build requests first page with configured page size', () async {
    stubPage(0, () async => _page(skip: 0, count: 20));

    final page = await container.read(productListProvider.future);

    expect(page.items, hasLength(20));
    verify(() => repository.getProducts(skip: 0, limit: 20)).called(1);
  });

  test('exposes repository failure as AsyncError', () async {
    stubPage(0, () async => throw const NetworkFailure());

    await expectLater(
      container.read(productListProvider.future),
      throwsA(isA<NetworkFailure>()),
    );
    expect(container.read(productListProvider).error, isA<NetworkFailure>());
  });

  test('loadMore appends next page and stops at total', () async {
    stubPage(0, () async => _page(skip: 0, count: 20));
    stubPage(20, () async => _page(skip: 20, count: 20));
    await container.read(productListProvider.future);
    final notifier = container.read(productListProvider.notifier);

    await notifier.loadMore();
    final page = container.read(productListProvider).requireValue;

    expect(page.items, hasLength(40));
    expect(page.items.last.id, 40);
    expect(page.hasMore, isFalse);

    await notifier.loadMore();
    verifyNever(() => repository.getProducts(skip: 40, limit: 20));
  });

  test('loadMore ignores calls while a page is loading', () async {
    final completer = Completer<ProductPage>();
    stubPage(0, () async => _page(skip: 0, count: 20));
    stubPage(20, () => completer.future);
    await container.read(productListProvider.future);
    final notifier = container.read(productListProvider.notifier);

    final first = notifier.loadMore();
    final second = notifier.loadMore();
    completer.complete(_page(skip: 20, count: 20));
    await Future.wait([first, second]);

    verify(() => repository.getProducts(skip: 20, limit: 20)).called(1);
    expect(
      container.read(productListProvider).requireValue.items,
      hasLength(40),
    );
  });

  test('loadMore keeps loaded items when next page fails', () async {
    stubPage(0, () async => _page(skip: 0, count: 20));
    stubPage(20, () async => throw const TimeoutFailure());
    await container.read(productListProvider.future);

    await container.read(productListProvider.notifier).loadMore();
    final state = container.read(productListProvider);

    expect(state.hasError, isFalse);
    expect(state.requireValue.items, hasLength(20));
    expect(state.requireValue.hasMore, isTrue);
  });

  group('filters', () {
    const smartphones = ProductCategory(
      slug: 'smartphones',
      name: 'Smartphones',
    );

    void stubSearch(String query, ProductPage page) {
      when(() => repository.searchProducts(query, skip: 0, limit: 0))
          .thenAnswer((_) async => page);
    }

    test('searches only the last query after the debounce', () async {
      stubPage(0, () async => _page(skip: 0, count: 20));
      stubSearch('phone', _page(skip: 0, count: 2, total: 2));
      container.listen(productListProvider, (previous, next) {});
      await container.read(productListProvider.future);
      final query = container.read(searchQueryProvider.notifier);

      query.change('p');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      query.change(' phone ');
      final page = await container.read(productListProvider.future);

      expect(page.items, hasLength(2));
      expect(page.hasMore, isFalse);
      verify(() => repository.searchProducts('phone', skip: 0, limit: 0))
          .called(1);
      verifyNever(() => repository.searchProducts('p', skip: 0, limit: 0));
    });

    test('category without query uses the category endpoint', () async {
      when(
        () =>
            repository.getProductsByCategory('smartphones', skip: 0, limit: 20),
      ).thenAnswer((_) async => _page(skip: 0, count: 5, total: 5));

      container.read(selectedCategoryProvider.notifier).toggle(smartphones);
      final page = await container.read(productListProvider.future);

      expect(page.items, hasLength(5));
      verifyNever(
        () => repository.getProducts(
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
        ),
      );
    });

    test('search inside a category filters results on the client', () async {
      final mixed = _page(skip: 0, count: 4, total: 4);
      stubSearch(
        'pro',
        mixed.copyWith(
          items: [
            for (final product in mixed.items)
              product.id.isEven
                  ? product.copyWith(category: 'smartphones')
                  : product,
          ],
        ),
      );

      container.listen(productListProvider, (previous, next) {});
      container.read(selectedCategoryProvider.notifier).toggle(smartphones);
      container.read(searchQueryProvider.notifier).change('pro');
      final page = await container.read(productListProvider.future);

      expect(page.items.map((product) => product.id), [2, 4]);
      expect(page.total, 2);
      expect(page.hasMore, isFalse);
    });

    test(
      'loadMore discards a page that arrives after a filter change',
      () async {
        final completer = Completer<ProductPage>();
        stubPage(0, () async => _page(skip: 0, count: 20));
        stubPage(20, () => completer.future);
        when(
          () => repository.getProductsByCategory(
            'smartphones',
            skip: 0,
            limit: 20,
          ),
        ).thenAnswer((_) async => _page(skip: 0, count: 5, total: 5));
        container.listen(productListProvider, (previous, next) {});
        await container.read(productListProvider.future);

        final loading = container.read(productListProvider.notifier).loadMore();
        container.read(selectedCategoryProvider.notifier).toggle(smartphones);
        await container.read(productListProvider.future);
        completer.complete(_page(skip: 20, count: 20));
        await loading;

        expect(
          container.read(productListProvider).requireValue.items,
          hasLength(5),
        );
      },
    );
  });
}
