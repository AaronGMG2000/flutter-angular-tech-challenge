import 'dart:async';

import 'package:catalog/features/cart/data/repositories/shared_prefs_cart_storage.dart';
import 'package:catalog/features/cart/domain/entities/cart_item.dart';
import 'package:catalog/features/cart/domain/entities/cart_state.dart';
import 'package:catalog/features/cart/domain/repositories/cart_storage.dart';
import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  bool _changedByUser = false;

  @override
  CartState build() {
    final storage = ref.watch(cartStorageProvider);
    unawaited(_restore(storage));
    listenSelf((previous, next) {
      if (previous != null) unawaited(storage.save(next.items));
    });
    return const CartState();
  }

  Future<void> _restore(CartStorage storage) async {
    final items = await storage.load();
    if (!ref.mounted || _changedByUser || items.isEmpty) return;
    state = CartState(items: items);
  }

  void _update(List<CartItem> items) {
    _changedByUser = true;
    state = CartState(items: items);
  }

  void add(Product product, {int quantity = 1}) {
    final items = state.items;
    final exists = items.any((item) => item.productId == product.id);
    _update(
      exists
          ? [
              for (final item in items)
                item.productId == product.id
                    ? item.copyWith(quantity: item.quantity + quantity)
                    : item,
            ]
          : [...items, CartItem.fromProduct(product, quantity: quantity)],
    );
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) return remove(productId);
    _update([
      for (final item in state.items)
        item.productId == productId ? item.copyWith(quantity: quantity) : item,
    ]);
  }

  void remove(int productId) {
    _update([
      for (final item in state.items)
        if (item.productId != productId) item,
    ]);
  }

  void clear() => _update(const []);
}
