import 'package:catalog/features/products/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_page.freezed.dart';

@freezed
abstract class ProductPage with _$ProductPage {
  const factory ProductPage({
    required List<Product> items,
    required int total,
    required int skip,
    required int limit,
  }) = _ProductPage;

  const ProductPage._();

  bool get hasMore => skip + items.length < total;
}
