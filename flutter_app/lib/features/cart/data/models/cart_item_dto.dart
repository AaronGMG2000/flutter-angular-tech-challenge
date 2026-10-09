import 'package:catalog/features/cart/domain/entities/cart_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_dto.freezed.dart';
part 'cart_item_dto.g.dart';

@freezed
abstract class CartItemDto with _$CartItemDto {
  const factory CartItemDto({
    required int productId,
    required String title,
    required double price,
    required String thumbnail,
    required int quantity,
  }) = _CartItemDto;

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);

  factory CartItemDto.fromEntity(CartItem item) => CartItemDto(
    productId: item.productId,
    title: item.title,
    price: item.price,
    thumbnail: item.thumbnail,
    quantity: item.quantity,
  );
}

extension CartItemDtoMapper on CartItemDto {
  CartItem toEntity() => CartItem(
    productId: productId,
    title: title,
    price: price,
    thumbnail: thumbnail,
    quantity: quantity,
  );
}
