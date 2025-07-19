import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindguardian/test_root.dart'; // Use test-friendly root without Firebase/Hive

void main() {
  testWidgets('MindGuardian tab rendering and navigation test', (WidgetTester tester) async {
    // Pump the test-safe app root
    await tester.pumpWidget(const AppRoot());

    // Confirm BottomNavigationBar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Confirm initial tab icon (Mood) is present
    expect(find.byIcon(Icons.self_improvement), findsOneWidget);

    // Switch to Agent tab
    await tester.tap(find.byIcon(Icons.psychology));
    await tester.pumpAndSettle();

    // Confirm Agent tab is active
    expect(find.byIcon(Icons.psychology), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    // Switch to Crisis tab
    await tester.tap(find.byIcon(Icons.warning));
    await tester.pumpAndSettle();

    // Confirm Crisis tab is active
    expect(find.byIcon(Icons.warning), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
