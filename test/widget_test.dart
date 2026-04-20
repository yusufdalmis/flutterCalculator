import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_calculator/main.dart';

void main() {
  testWidgets('Calculator loads and can evaluate 1+1', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.text('Scientific Calculator'), findsOneWidget);
    expect(find.text('0'), findsWidgets);

    await tester.tap(find.text('1').first);
    await tester.tap(find.text('+').first);
    await tester.tap(find.text('1').first);
    await tester.tap(find.text('=').first);
    await tester.pump();

    expect(find.text('2'), findsWidgets);
  });
}
