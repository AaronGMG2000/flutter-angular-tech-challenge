import 'package:catalog/app.dart';
import 'package:catalog/core/error/failure.dart';
import 'package:catalog/core/theme/app_theme.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/domain/repositories/product_repository.dart';
import 'package:catalog/features/products/presentation/screens/product_detail_screen.dart';
import 'package:catalog/features/products/presentation/widgets/product_card.dart';
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
    id: 7,
    title: 'iPhone 13 Pro',
    description: 'Sistema de cámaras avanzado.',
    category: 'smartphones',
    price: 1099.99,
    discountPercentage: 9.37,
    rating: 4.12,
    stock: 56,
    thumbnail: 'https://cdn.dummyjson.com/thumbnail.png',
    images: [],
  );

  setUp(() {
    repository = _MockProductRepository();
    when(() => repository.getCategories()).thenAnswer((_) async => const []);
  });

  Future<void> pumpDetail(WidgetTester tester, int id) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
        retry: (retryCount, error) => null,
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLang.localizationsDelegates,
          supportedLocales: AppLang.supportedLocales,
          home: ProductDetailScreen(id: id),
        ),
      ),
    );
  }

  testWidgets('shows the product detail', (tester) async {
    when(() => repository.getProductById(7)).thenAnswer((_) async => product);

    await pumpDetail(tester, 7);
    await tester.pumpAndSettle();

    expect(find.text('iPhone 13 Pro'), findsOneWidget);
    expect(find.text(r'$1.099,99'), findsOneWidget);
    expect(find.text('-9,37 %'), findsOneWidget);
    expect(find.text('4,12'), findsOneWidget);
    expect(find.text('smartphones'), findsOneWidget);
    expect(find.text(lang.inStock(56)), findsOneWidget);
  });

  testWidgets('shows not found error and retries', (tester) async {
    var calls = 0;
    when(() => repository.getProductById(999)).thenAnswer((_) async {
      calls++;
      throw const NotFoundFailure();
    });

    await pumpDetail(tester, 999);
    await tester.pumpAndSettle();

    expect(find.text(lang.productErrorTitle), findsOneWidget);
    expect(find.text(lang.productErrorMessage(999)), findsOneWidget);

    await tester.tap(find.text(lang.retry));
    await tester.pumpAndSettle();

    expect(calls, 2);
  });

  testWidgets('network error shows the connection message', (tester) async {
    when(() => repository.getProductById(7))
        .thenAnswer((_) async => throw const NetworkFailure());

    await pumpDetail(tester, 7);
    await tester.pumpAndSettle();

    expect(find.text(lang.productsErrorMessage), findsOneWidget);
  });

  testWidgets('tapping a card opens its detail and back returns', (
    tester,
  ) async {
    when(() => repository.getProducts(skip: 0, limit: 20)).thenAnswer(
      (_) async =>
          const ProductPage(items: [product], total: 1, skip: 0, limit: 20),
    );
    when(() => repository.getProductById(7)).thenAnswer((_) async => product);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ProductCard));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsOneWidget);
    expect(find.text('-9,37 %'), findsOneWidget);

    await tester.tap(find.byTooltip(lang.back));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsNothing);
    expect(find.byType(ProductCard), findsOneWidget);
  });

  testWidgets('adds the selected quantity to the cart', (tester) async {
    when(() => repository.getProductById(7)).thenAnswer((_) async => product);

    await pumpDetail(tester, 7);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(lang.increase));
    await tester.tap(find.byTooltip(lang.increase));
    await tester.pump();
    await tester.tap(find.text(lang.addToCart));
    await tester.pump();

    expect(find.text(lang.addedToCart), findsOneWidget);
    expect(find.text('3'), findsNWidgets(2));
  });
}
