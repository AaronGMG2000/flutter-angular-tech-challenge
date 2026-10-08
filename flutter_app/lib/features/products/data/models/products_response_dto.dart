import 'package:catalog/features/products/data/models/product_dto.dart';
import 'package:catalog/features/products/domain/entities/product_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_response_dto.freezed.dart';
part 'products_response_dto.g.dart';

@freezed
abstract class ProductsResponseDto with _$ProductsResponseDto {
  const factory ProductsResponseDto({
    required List<ProductDto> products,
    required int total,
    required int skip,
    required int limit,
  }) = _ProductsResponseDto;

  factory ProductsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseDtoFromJson(json);
}

extension ProductsResponseDtoMapper on ProductsResponseDto {
  ProductPage toEntity() => ProductPage(
    items: products.map((dto) => dto.toEntity()).toList(),
    total: total,
    skip: skip,
    limit: limit,
  );
}
