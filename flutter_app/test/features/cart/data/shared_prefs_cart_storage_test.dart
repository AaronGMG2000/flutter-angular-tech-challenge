import 'package:catalog/features/cart/data/repositories/shared_prefs_cart_storage.dart';
import 'package:catalog/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late SharedPreferencesAsync prefs;
  late SharedPrefsCartStorage storage;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
    storage = SharedPrefsCartStorage(prefs);
  });

  const item = CartItem(
    productId: 1,
    title: 'Essence Mascara',
    price: 9.99,
    thumbnail: 'https://cdn.dummyjson.com/1.png',
    quantity: 2,
  );

  test('saved items load back equal', () async {
    await storage.save([item]);

    expect(await storage.load(), [item]);
  });

  test('empty storage loads an empty cart', () async {
    expect(await storage.load(), isEmpty);
  });

  test('corrupted data loads an empty cart', () async {
    await prefs.setString('cart.items', '{not json');

    expect(await storage.load(), isEmpty);
  });
}
