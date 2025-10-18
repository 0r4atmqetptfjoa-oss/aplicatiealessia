import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumea_alessiei/src/features/main_menu/main_menu_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';

void main() {
  testWidgets('MainMenuScreen golden test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MainMenuScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(MainMenuScreen),
      matchesGoldenFile('goldens/main_menu_screen.png'),
    );
  });
}
