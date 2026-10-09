import 'package:catalog/app.dart';
import 'package:catalog/core/theme/index.dart';
import 'package:catalog/features/cart/presentation/screens/cart_screen.dart';
import 'package:catalog/features/cart/presentation/widgets/cart_badge.dart';
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

  testWidgets('search, open the result, add it and check the cart total', (
    tester,
  ) async {
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
    when(() => repository.getProductById(2)).thenAnswer((_) async => iphone);

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

    await tester.tap(find.text(iphone.title));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailScreen), findsOneWidget);
    verify(() => repository.getProductById(2)).called(1);

    await tester.tap(find.byTooltip(lang.increase));
    await tester.pump();
    await tester.tap(find.text(lang.addToCart));
    await tester.pumpAndSettle();

    final badge = find.byType(CartBadge);
    expect(
      find.descendant(of: badge, matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: badge, matching: find.text(r'$2.199,98')),
      findsOneWidget,
    );

    await tester.tap(badge);
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.text(r'$2.199,98'), findsNWidgets(4));

    await tester.pump(AppDurations.toast);
    await tester.pumpAndSettle();
    await tester.tap(find.text(lang.clearCart));
    await tester.pumpAndSettle();
    expect(find.text(lang.cartEmpty), findsOneWidget);
  });
}
