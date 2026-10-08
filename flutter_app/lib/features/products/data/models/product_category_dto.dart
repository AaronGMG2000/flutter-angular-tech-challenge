import 'package:catalog/features/products/domain/entities/product_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_category_dto.freezed.dart';
part 'product_category_dto.g.dart';

@freezed
abstract class ProductCategoryDto with _$ProductCategoryDto {
  const factory ProductCategoryDto({
    required String slug,
    required String name,
  }) = _ProductCategoryDto;

  factory ProductCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryDtoFromJson(json);
}

extension ProductCategoryDtoMapper on ProductCategoryDto {
  ProductCategory toEntity() => ProductCategory(slug: slug, name: name);
}
