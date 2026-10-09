import 'package:catalog/core/storage/preferences_provider.dart';
import 'package:catalog/core/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late SharedPreferencesAsync prefs;
  late ProviderContainer container;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
    container = ProviderContainer.test(
      overrides: [preferencesProvider.overrideWithValue(prefs)],
    );
  });

  test('starts in light mode', () {
    expect(container.read(themeModeProvider), ThemeMode.light);
  });

  test('toggle switches mode and saves it', () async {
    container.read(themeModeProvider.notifier).toggle();
    await Future<void>.delayed(Duration.zero);

    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(await prefs.getString('theme.mode'), 'dark');

    container.read(themeModeProvider.notifier).toggle();
    expect(container.read(themeModeProvider), ThemeMode.light);
  });

  test('restores the saved mode', () async {
    await prefs.setString('theme.mode', 'dark');

    container.read(themeModeProvider);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
