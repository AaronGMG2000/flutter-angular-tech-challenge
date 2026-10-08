import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catalog/app.dart';
import 'package:catalog/l10n/app_lang_es.dart';

void main() {
  testWidgets('App arranca y muestra el título', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.text(AppLangEs().appTitle), findsOneWidget);
  });
}
