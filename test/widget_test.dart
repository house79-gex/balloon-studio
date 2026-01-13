import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_design_studio/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BalloonDesignStudioApp());

    // Verify that the app title is present
    expect(find.text('Balloon Design Studio'), findsOneWidget);
    
    // Verify that welcome message is present
    expect(find.text('Welcome to Balloon Design Studio'), findsOneWidget);
  });
}
