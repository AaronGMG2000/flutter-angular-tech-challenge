import 'dart:async';

import 'package:catalog/core/error/failure.dart';
import 'package:catalog/core/theme/app_theme.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/domain/entities/product_category.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/domain/repositories/product_repository.dart';
import 'package:catalog/features/products/presentation/screens/products_screen.dart';
import 'package:catalog/features/products/presentation/widgets/load_more_indicator.dart';
import 'package:catalog/features/products/presentation/widgets/product_card.dart';
import 'package:catalog/features/products/presentation/widgets/product_grid_skeleton.dart';
import 'package:catalog/features/products/presentation/widgets/product_list_skeleton.dart';
import 'package:catalog/features/products/presentation/widgets/product_list_tile.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:catalog/l10n/app_lang_es.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late _MockProductRepository repository;
  final lang = AppLangEs();

  const product = Product(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    description: 'Popular mascara',
    category: 'beauty',
    price: 9.99,
    discountPercentage: 7.17,
    rating: 4.94,
    stock: 5,
    thumbnail: 'https://cdn.dummyjson.com/thumbnail.png',
    images: [],
  );
  const page = ProductPage(items: [product], total: 1, skip: 0, limit: 20);

  setUp(() {
    repository = _MockProductRepository();
    when(() => repository.getCategories()).thenAnswer(
      (_) async => const [
        ProductCategory(slug: 'smartphones', name: 'Smartphones'),
      ],
    );
  });

  Future<void> pumpScreen(WidgetTester tester) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
        retry: (retryCount, error) => null,
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLang.localizationsDelegates,
          supportedLocales: AppLang.supportedLocales,
          home: const ProductsScreen(),
        ),
      ),
    );
  }

  void stubProducts(Future<ProductPage> Function() answer) {
    when(() => repository.getProducts(skip: 0, limit: 20))
        .thenAnswer((_) => answer());
  }

  testWidgets('shows skeleton while loading and then the grid', (tester) async {
    final completer = Completer<ProductPage>();
    stubProducts(() => completer.future);

    await pumpScreen(tester);
    await tester.pump();

    expect(find.byType(ProductGridSkeleton), findsOneWidget);

    completer.complete(page);
    await tester.pumpAndSettle();

    expect(find.byType(ProductGridSkeleton), findsNothing);
    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text(product.title), findsOneWidget);
    expect(find.text(r'$9,99'), findsOneWidget);
    expect(find.text('4,94'), findsOneWidget);
  });

  testWidgets('shows error view and retries on tap', (tester) async {
    var calls = 0;
    stubProducts(() async {
      calls++;
      if (calls == 1) throw const NetworkFailure();
      return page;
    });

    await pumpScreen(tester);
    await tester.pumpAndSettle();

    expect(find.text(lang.productsErrorTitle), findsOneWidget);

    await tester.tap(find.text(lang.retry));
    await tester.pumpAndSettle();

    expect(calls, 2);
    expect(find.text(product.title), findsOneWidget);
  });

  testWidgets('loads next page when scrolling near the end', (tester) async {
    List<Product> productsFrom(int start) => List.generate(
      20,
      (index) => product.copyWith(
        id: start + index,
        title: 'Product ${start + index}',
      ),
    );
    stubProducts(
      () async =>
          ProductPage(items: productsFrom(1), total: 40, skip: 0, limit: 20),
    );
    when(() => repository.getProducts(skip: 20, limit: 20)).thenAnswer(
      (_) async =>
          ProductPage(items: productsFrom(21), total: 40, skip: 20, limit: 20),
    );

    await pumpScreen(tester);
    await tester.pump();
    await tester.pump();

    expect(find.byType(LoadMoreIndicator, skipOffstage: false), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Product 40'),
      500,
      scrollable: find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();

    verify(() => repository.getProducts(skip: 20, limit: 20)).called(1);
    expect(find.text('Product 40'), findsOneWidget);
    expect(find.byType(LoadMoreIndicator, skipOffstage: false), findsNothing);
  });

  testWidgets('shows empty view when the page has no items', (tester) async {
    stubProducts(
      () async => const ProductPage(items: [], total: 0, skip: 0, limit: 20),
    );

    await pumpScreen(tester);
    await tester.pumpAndSettle();

    expect(find.text(lang.emptyTitle), findsOneWidget);
    expect(find.byType(ProductCard), findsNothing);
  });

  testWidgets('searches after the debounce and shows the result list', (
    tester,
  ) async {
    stubProducts(() async => page);
    when(() => repository.searchProducts('mascara', skip: 0, limit: 0))
        .thenAnswer((_) async => page);

    await pumpScreen(tester);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'mascara');
    await tester.pump();

    expect(find.byType(ProductListSkeleton), findsOneWidget);
    expect(find.text(lang.searching('mascara')), findsOneWidget);
    verifyNever(
      () => repository.searchProducts(
        any(),
        skip: any(named: 'skip'),
        limit: any(named: 'limit'),
      ),
    );

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.byType(ProductListTile), findsOneWidget);
    expect(find.text(lang.searchResultsCount(1, 'mascara')), findsOneWidget);
    verify(() => repository.searchProducts('mascara', skip: 0, limit: 0))
        .called(1);
  });

  testWidgets('empty search offers to clear the filters', (tester) async {
    stubProducts(() async => page);
    when(() => repository.searchProducts('zzz', skip: 0, limit: 0)).thenAnswer(
      (_) async => const ProductPage(items: [], total: 0, skip: 0, limit: 0),
    );

    await pumpScreen(tester);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text(lang.emptyMessage('zzz')), findsOneWidget);

    await tester.tap(find.text(lang.clearSearch));
    await tester.pumpAndSettle();

    expect(find.byType(ProductCard), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      isEmpty,
    );
  });

  testWidgets('tapping a category chip loads that category', (tester) async {
    stubProducts(() async => page);
    when(
      () => repository.getProductsByCategory('smartphones', skip: 0, limit: 20),
    ).thenAnswer((_) async => page);

    await pumpScreen(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Smartphones'));
    await tester.pumpAndSettle();

    verify(
      () => repository.getProductsByCategory('smartphones', skip: 0, limit: 20),
    ).called(1);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });
}
