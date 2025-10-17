import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumea_alessiei/src/features/main_menu/main_menu_screen.dart';

void main() {
  testWidgets('_MenuButton smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _MenuButton(label: 'Test', onTap: () {}),
        ),
      ),
    );

    // Verify that our button has the correct label.
    expect(find.text('Test'), findsOneWidget);
  });
}
