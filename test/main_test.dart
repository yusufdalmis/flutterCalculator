import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calculator/main.dart';

void main() {
  testWidgets('renders scientific calculator layout and computes simple operation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.text('Scientific Calculator'), findsOneWidget);
    expect(find.text('sin('), findsOneWidget);
    expect(find.text('cos('), findsOneWidget);
    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);

    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('4'), findsWidgets);
  });
}
