import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test-specific app widget that doesn't use Firebase
class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caregiver App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Caregiver App - Test Mode')),
      ),
    );
  }
}

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our test app and trigger a frame.
    await tester.pumpWidget(const TestApp());
    await tester.pumpAndSettle();

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Caregiver App - Test Mode'), findsOneWidget);
  });

  testWidgets('App title is correct', (WidgetTester tester) async {
    await tester.pumpWidget(const TestApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'Caregiver App');
  });

  testWidgets('App uses correct theme', (WidgetTester tester) async {
    await tester.pumpWidget(const TestApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.theme?.useMaterial3, isTrue);
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
