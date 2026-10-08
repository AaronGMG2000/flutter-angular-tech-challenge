import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catalog/core/router/app_router.dart';
import 'package:catalog/core/theme/app_theme.dart';
import 'package:catalog/l10n/app_lang.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLang.of(context).appTitle,
      localizationsDelegates: AppLang.localizationsDelegates,
      supportedLocales: AppLang.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
