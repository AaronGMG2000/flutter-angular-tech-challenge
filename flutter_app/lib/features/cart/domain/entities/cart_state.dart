import 'package:catalog/features/cart/domain/entities/cart_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_state.freezed.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState({@Default(<CartItem>[]) List<CartItem> items}) =
      _CartState;

  const CartState._();

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  bool get isEmpty => items.isEmpty;

  int quantityOf(int productId) => items
      .where((item) => item.productId == productId)
      .fold(0, (sum, item) => sum + item.quantity);
}
