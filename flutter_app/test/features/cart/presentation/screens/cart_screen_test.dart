import 'package:catalog/core/theme/app_theme.dart';
import 'package:catalog/features/cart/data/repositories/shared_prefs_cart_storage.dart';
import 'package:catalog/features/cart/domain/entities/cart_item.dart';
import 'package:catalog/features/cart/domain/repositories/cart_storage.dart';
import 'package:catalog/features/cart/presentation/screens/cart_screen.dart';
import 'package:catalog/features/cart/presentation/widgets/cart_badge.dart';
import 'package:catalog/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:catalog/l10n/app_lang.dart';
import 'package:catalog/l10n/app_lang_es.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryCartStorage implements CartStorage {
  _MemoryCartStorage(this.items);

  List<CartItem> items;

  @override
  Future<List<CartItem>> load() async => items;

  @override
  Future<void> save(List<CartItem> items) async => this.items = items;
}

void main() {
  final lang = AppLangEs();

  const mascara = CartItem(
    productId: 1,
    title: 'Essence Mascara',
    price: 9.99,
    thumbnail: 'https://cdn.dummyjson.com/1.png',
    quantity: 2,
  );
  const lipstick = CartItem(
    productId: 2,
    title: 'Red Lipstick',
    price: 12.99,
    thumbnail: 'https://cdn.dummyjson.com/2.png',
    quantity: 1,
  );

  Future<void> pumpCart(WidgetTester tester, List<CartItem> items) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartStorageProvider.overrideWithValue(_MemoryCartStorage(items)),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLang.localizationsDelegates,
          supportedLocales: AppLang.supportedLocales,
          home: const Scaffold(
            body: Column(
              children: [
                CartBadge(borderColor: Colors.white),
                Expanded(child: CartScreen()),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows lines, units and total', (tester) async {
    await pumpCart(tester, [mascara, lipstick]);

    expect(find.byType(CartItemTile), findsNWidgets(2));
    expect(find.text(lang.cartUnits(3)), findsOneWidget);
    expect(find.text(lang.cartSubtotal(3)), findsOneWidget);
    expect(find.text(r'$32,97'), findsNWidgets(2));
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('stepper and delete update the cart and the badge', (
    tester,
  ) async {
    await pumpCart(tester, [mascara, lipstick]);

    await tester.tap(find.byTooltip(lang.increase).first);
    await tester.pump();
    expect(find.text('4'), findsOneWidget);

    await tester.tap(find.byTooltip(lang.removeFromCart).last);
    await tester.pump();
    expect(find.byType(CartItemTile), findsOneWidget);
    expect(find.text('3'), findsNWidgets(2));
  });

  testWidgets('clear empties the cart and hides the badge', (tester) async {
    await pumpCart(tester, [mascara]);

    await tester.tap(find.text(lang.clearCart));
    await tester.pump();

    expect(find.text(lang.cartEmpty), findsOneWidget);
    expect(find.text(lang.goToCatalog), findsOneWidget);
    expect(find.text('2'), findsNothing);
  });
}
