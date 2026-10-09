import 'package:catalog/features/cart/domain/entities/cart_item.dart';

abstract interface class CartStorage {
  Future<List<CartItem>> load();

  Future<void> save(List<CartItem> items);
}
