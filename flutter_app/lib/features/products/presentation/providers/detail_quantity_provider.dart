import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail_quantity_provider.g.dart';

@riverpod
class DetailQuantity extends _$DetailQuantity {
  @override
  int build(int productId) => 1;

  void increment() => state++;

  void decrement() {
    if (state > 1) state--;
  }
}
