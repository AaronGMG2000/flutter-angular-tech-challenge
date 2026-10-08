import 'package:catalog/core/error/failure.dart';
import 'package:catalog/features/products/data/repositories/product_repository_impl.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:catalog/features/products/domain/repositories/product_repository.dart';
import 'package:catalog/features/products/presentation/providers/product_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late _MockProductRepository repository;
  late ProviderContainer container;

  const emptyPage = ProductPage(items: [], total: 0, skip: 0, limit: 20);

  setUp(() {
    repository = _MockProductRepository();
    container = ProviderContainer.test(
      overrides: [productRepositoryProvider.overrideWithValue(repository)],
      retry: (retryCount, error) => null,
    );
  });

  test('build requests first page with configured page size', () async {
    when(() => repository.getProducts(skip: 0, limit: 20))
        .thenAnswer((_) async => emptyPage);

    final page = await container.read(productListProvider.future);

    expect(page, emptyPage);
    verify(() => repository.getProducts(skip: 0, limit: 20)).called(1);
  });

  test('exposes repository failure as AsyncError', () async {
    when(() => repository.getProducts(skip: 0, limit: 20))
        .thenThrow(const NetworkFailure());

    await expectLater(
      container.read(productListProvider.future),
      throwsA(isA<NetworkFailure>()),
    );
    expect(container.read(productListProvider).error, isA<NetworkFailure>());
  });
}
