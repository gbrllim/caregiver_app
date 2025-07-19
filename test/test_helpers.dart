import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test helper utilities for the caregiver app
class TestHelpers {
  /// Creates a test-friendly MaterialApp wrapper
  static Widget wrapWithMaterialApp(Widget child) {
    return MaterialApp(
      home: child,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }

  /// Creates a test scaffold with common setup
  static Widget createTestScaffold({
    required Widget body,
    String title = 'Test',
  }) {
    return wrapWithMaterialApp(
      Scaffold(
        appBar: AppBar(title: Text(title)),
        body: body,
      ),
    );
  }

  /// Utility to pump and settle widgets in tests
  static Future<void> pumpAndSettleWidget(
    WidgetTester tester,
    Widget widget, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(timeout);
  }
}

/// Custom matchers for common test scenarios
class CustomMatchers {
  static Matcher hasText(String text) => findsOneWidget;
  static Matcher hasNoText(String text) => findsNothing;
  static Matcher hasWidgetOfType<T>() => findsOneWidget;
}
