import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required int productId,
    required String title,
    required double price,
    required String thumbnail,
    required int quantity,
  }) = _CartItem;

  const CartItem._();

  factory CartItem.fromProduct(Product product, {required int quantity}) {
    return CartItem(
      productId: product.id,
      title: product.title,
      price: product.price,
      thumbnail: product.thumbnail,
      quantity: quantity,
    );
  }

  double get subtotal => price * quantity;
}
