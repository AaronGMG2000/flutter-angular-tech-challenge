import 'package:catalog/app.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/screens/cart_screen.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/domain/repositories/product_repository.dart';
import 'package:catalog/features/products/presentation/screens/product_detail_screen.dart';
import 'package:catalog/features/products/presentation/widgets/product_card.dart';
import 'package:catalog/features/products/presentation/widgets/product_list_tile.dart';
import 'package:catalog/l10n/app_lang_es.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProductRepository extends Mock implements ProductRepository {}

void main() {
  final lang = AppLangEs();

  const mascara = Product(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    description: 'Popular mascara',
    category: 'beauty',
    price: 9.99,
    discountPercentage: 7.17,
    rating: 4.94,
    stock: 5,
    thumbnail: 'https://cdn.dummyjson.com/1.png',
    images: [],
  );
  const iphone = Product(
    id: 2,
    title: 'iPhone 13 Pro',
    description: 'Smartphone',
    category: 'smartphones',
    price: 1099.99,
    discountPercentage: 9.37,
    rating: 4.12,
    stock: 56,
    thumbnail: 'https://cdn.dummyjson.com/2.png',
    images: [],
  );

  testWidgets('search, add from the list, add from detail and pay attention '
      'to the total', (tester) async {
    final repository = _MockProductRepository();
    when(() => repository.getCategories()).thenAnswer((_) async => const []);
    when(() => repository.getProducts(skip: 0, limit: 20)).thenAnswer(
      (_) async => const ProductPage(
        items: [mascara, iphone],
        total: 2,
        skip: 0,
        limit: 20,
      ),
    );
    when(() => repository.searchProducts('iphone', skip: 0, limit: 0))
        .thenAnswer(
          (_) async =>
              const ProductPage(items: [iphone], total: 1, skip: 0, limit: 0),
        );
    when(() => repository.getProductById(1)).thenAnswer((_) async => mascara);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsNWidgets(2));

    await tester.enterText(find.byType(TextField), 'iphone');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.byType(ProductListTile), findsOneWidget);

    await tester.tap(find.byTooltip(lang.addToCart));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(lang.addToCart));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(lang.clearSearchTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.text(mascara.title));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailScreen), findsOneWidget);

    await tester.tap(find.byTooltip(lang.increase));
    await tester.pump();
    await tester.tap(find.text(lang.addToCart));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(lang.cartTitle));
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.text(lang.cartUnits(4)), findsOneWidget);
    expect(find.text(r'$2.219,96'), findsNWidgets(2));

    await tester.pump(AppDurations.toast);
    await tester.pumpAndSettle();
    await tester.tap(find.text(lang.clearCart));
    await tester.pumpAndSettle();
    expect(find.text(lang.cartEmpty), findsOneWidget);
  });
}
