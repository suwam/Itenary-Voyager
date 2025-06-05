import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // Make sure this matches your actual package name

void main() {
  testWidgets('Login button is visible on start', (WidgetTester tester) async {
    // Build your app
    await tester.pumpWidget(const flutter_application_1());

    // Check that Login button is present
    expect(find.text('Login'), findsOneWidget);
  });
}
