import 'dart:convert';

import 'package:catalog/core/storage/preferences_provider.dart';
import 'package:catalog/features/cart/data/models/cart_item_dto.dart';
import 'package:catalog/features/cart/domain/entities/cart_item.dart';
import 'package:catalog/features/cart/domain/repositories/cart_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_cart_storage.g.dart';

const String _cartKey = 'cart.items';

class SharedPrefsCartStorage implements CartStorage {
  const SharedPrefsCartStorage(this._prefs);

  final SharedPreferencesAsync _prefs;

  @override
  Future<List<CartItem>> load() async {
    final raw = await _prefs.getString(_cartKey);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((json) => CartItemDto.fromJson(json).toEntity())
          .toList();
    } on FormatException {
      return const [];
    } on TypeError {
      return const [];
    }
  }

  @override
  Future<void> save(List<CartItem> items) {
    final json = items.map((item) => CartItemDto.fromEntity(item).toJson());
    return _prefs.setString(_cartKey, jsonEncode(json.toList()));
  }
}

@Riverpod(keepAlive: true)
CartStorage cartStorage(Ref ref) {
  return SharedPrefsCartStorage(ref.watch(preferencesProvider));
}
