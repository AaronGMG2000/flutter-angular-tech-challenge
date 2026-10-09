import 'dart:async';

import 'package:catalog/core/storage/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

const String _themeModeKey = 'theme.mode';

@Riverpod(keepAlive: true, name: 'themeModeProvider')
class AppThemeMode extends _$AppThemeMode {
  bool _changedByUser = false;

  @override
  ThemeMode build() {
    unawaited(_restore());
    return ThemeMode.light;
  }

  Future<void> _restore() async {
    final saved = await ref.read(preferencesProvider).getString(_themeModeKey);
    final mode = ThemeMode.values.asNameMap()[saved];
    if (!ref.mounted || _changedByUser || mode == null) return;
    state = mode;
  }

  void toggle() {
    _changedByUser = true;
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    unawaited(
      ref.read(preferencesProvider).setString(_themeModeKey, state.name),
    );
  }
}
