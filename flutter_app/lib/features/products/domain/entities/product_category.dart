import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_category.freezed.dart';

@freezed
abstract class ProductCategory with _$ProductCategory {
  const factory ProductCategory({required String slug, required String name}) =
      _ProductCategory;
}
