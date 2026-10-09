import 'package:catalog/features/cart/data/repositories/shared_prefs_cart_storage.dart';
import 'package:catalog/features/cart/domain/entities/cart_item.dart';
import 'package:catalog/features/cart/domain/repositories/cart_storage.dart';
import 'package:catalog/features/cart/presentation/providers/cart_provider.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryCartStorage implements CartStorage {
  _MemoryCartStorage([this.items = const []]);

  List<CartItem> items;
  int saves = 0;

  @override
  Future<List<CartItem>> load() async => items;

  @override
  Future<void> save(List<CartItem> items) async {
    saves++;
    this.items = items;
  }
}

Product _product(int id, {double price = 10}) => Product(
  id: id,
  title: 'Product $id',
  description: '',
  category: 'beauty',
  price: price,
  discountPercentage: 0,
  rating: 4,
  stock: 10,
  thumbnail: 'https://cdn.dummyjson.com/$id.png',
  images: const [],
);

void main() {
  late _MemoryCartStorage storage;
  late ProviderContainer container;

  ProviderContainer createContainer() => ProviderContainer.test(
    overrides: [cartStorageProvider.overrideWithValue(storage)],
  );

  setUp(() {
    storage = _MemoryCartStorage();
    container = createContainer();
  });

  Cart cart() => container.read(cartProvider.notifier);

  test('add creates a line and adding again sums one', () {
    cart().add(_product(1));
    cart().add(_product(1));
    cart().add(_product(2), quantity: 3);

    final state = container.read(cartProvider);
    expect(state.items, hasLength(2));
    expect(state.items.first.quantity, 2);
    expect(state.totalItems, 5);
  });

  test('total multiplies price by quantity', () {
    cart().add(_product(1, price: 9.99), quantity: 2);
    cart().add(_product(2, price: 5));

    expect(container.read(cartProvider).total, closeTo(24.98, 0.001));
  });

  test('updating quantity to zero removes the line', () {
    cart().add(_product(1));
    cart().add(_product(2));

    cart().updateQuantity(1, 0);

    final items = container.read(cartProvider).items;
    expect(items.map((item) => item.productId), [2]);
  });

  test('every change produces a new list', () {
    cart().add(_product(1));
    final before = container.read(cartProvider).items;

    cart().updateQuantity(1, 4);
    final after = container.read(cartProvider).items;

    expect(identical(before, after), isFalse);
    expect(before.single.quantity, 1);
    expect(after.single.quantity, 4);
  });

  test('quantityOf returns units per product', () {
    cart().add(_product(1), quantity: 2);
    cart().add(_product(1));

    final state = container.read(cartProvider);
    expect(state.quantityOf(1), 3);
    expect(state.quantityOf(2), 0);
  });

  test('remove and clear', () {
    cart().add(_product(1));
    cart().add(_product(2));

    cart().remove(1);
    expect(container.read(cartProvider).items, hasLength(1));

    cart().clear();
    expect(container.read(cartProvider).isEmpty, isTrue);
  });

  test('restores saved items and persists changes', () async {
    storage = _MemoryCartStorage([
      CartItem.fromProduct(_product(7), quantity: 2),
    ]);
    container = createContainer();

    container.read(cartProvider);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(cartProvider).totalItems, 2);

    cart().add(_product(7));
    await Future<void>.delayed(Duration.zero);

    expect(storage.items.single.quantity, 3);
  });
}
