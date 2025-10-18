import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lumea_alessiei/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E: Tap sound category and verify navigation', (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    // Wait for the splash screen and navigation to complete
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify we are on the main menu
    expect(find.text('Sunete'), findsOneWidget);

    // Tap the 'Sunete' button
    await tester.tap(find.text('Sunete'));
    await tester.pumpAndSettle();

    // Verify we have navigated to the sounds menu
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Sunete'), findsOneWidget);
  });
}
