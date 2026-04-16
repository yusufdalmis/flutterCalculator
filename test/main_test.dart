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

    final resultText = tester.widget<Text>(find.byKey(const ValueKey('resultText')));
    expect(resultText.data, '4');

    await tester.tap(find.text('C'));
    await tester.tap(find.text('+'));
    await tester.pump();

    final equationText = tester.widget<Text>(find.byKey(const ValueKey('equationText')));
    expect(equationText.data, '0+');
  });
}
