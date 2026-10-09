import 'package:catalog/app.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/domain/repositories/product_repository.dart';
import 'package:catalog/l10n/app_lang_es.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProductRepository extends Mock implements ProductRepository {}

void main() {
  testWidgets('app starts and shows the title', (tester) async {
    final repository = _MockProductRepository();
    when(() => repository.getCategories()).thenAnswer((_) async => const []);
    when(() => repository.getProducts(skip: 0, limit: 20)).thenAnswer(
      (_) async => const ProductPage(items: [], total: 0, skip: 0, limit: 20),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppLangEs().appTitle), findsOneWidget);
  });

  testWidgets('theme button switches between light and dark', (tester) async {
    final repository = _MockProductRepository();
    when(() => repository.getCategories()).thenAnswer((_) async => const []);
    when(() => repository.getProducts(skip: 0, limit: 20)).thenAnswer(
      (_) async => const ProductPage(items: [], total: 0, skip: 0, limit: 20),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    Brightness brightness() =>
        Theme.of(tester.element(find.byType(Scaffold))).brightness;

    expect(brightness(), Brightness.light);
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    await tester.tap(find.byTooltip(AppLangEs().toggleTheme));
    await tester.pumpAndSettle();

    expect(brightness(), Brightness.dark);
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });
}
