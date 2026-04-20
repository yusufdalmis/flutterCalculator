import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scientific Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF111111),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '0';

  void _append(String value) {
    setState(() {
      _expression += value;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  void _backspace() {
    if (_expression.isEmpty) {
      return;
    }
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
    });
  }

  void _evaluate() {
    if (_expression.trim().isEmpty) {
      return;
    }

    final parser = ShuntingYardParser();
    final contextModel = ContextModel();
    final normalized = _normalizeExpression(_expression);

    try {
      final exp = parser.parse(normalized);
      final value = exp.evaluate(EvaluationType.REAL, contextModel);

      setState(() {
        if (value.isNaN || value.isInfinite) {
          _result = 'Error';
          return;
        }

        final rounded = value.toStringAsFixed(10);
        _result = rounded.replaceFirst(RegExp(r'\\.?0+$'), '');
      });
    } catch (_) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  String _normalizeExpression(String input) {
    return input
        .replaceAll('x', '*')
        .replaceAll('sqrt(', 'sqrt(')
        .replaceAll('log(', 'log(')
        .replaceAll('--', '+');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Scientific Calculator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _result,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 68,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buttonRow([
              _key('sin(', _ButtonStyle.scientific),
              _key('cos(', _ButtonStyle.scientific),
              _key('tan(', _ButtonStyle.scientific),
              _key('log(', _ButtonStyle.scientific),
            ]),
            _buttonRow([
              _key('sqrt(', _ButtonStyle.scientific),
              _key('^', _ButtonStyle.scientific),
              _key('(', _ButtonStyle.scientific),
              _key(')', _ButtonStyle.scientific),
            ]),
            _buttonRow([
              _key('7', _ButtonStyle.number),
              _key('8', _ButtonStyle.number),
              _key('9', _ButtonStyle.number),
              _key('/', _ButtonStyle.operator),
            ]),
            _buttonRow([
              _key('4', _ButtonStyle.number),
              _key('5', _ButtonStyle.number),
              _key('6', _ButtonStyle.number),
              _key('x', _ButtonStyle.operator),
            ]),
            _buttonRow([
              _key('1', _ButtonStyle.number),
              _key('2', _ButtonStyle.number),
              _key('3', _ButtonStyle.number),
              _key('-', _ButtonStyle.operator),
            ]),
            _buttonRow([
              _key('0', _ButtonStyle.number),
              _key('.', _ButtonStyle.number),
              _key('DEL', _ButtonStyle.danger),
              _key('+', _ButtonStyle.operator),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: _CalcButton(
                      label: 'C',
                      buttonStyle: _ButtonStyle.danger,
                      onTap: _clear,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _CalcButton(
                      label: '=',
                      buttonStyle: _ButtonStyle.equals,
                      onTap: _evaluate,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buttonRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(children: children),
    );
  }

  Widget _key(String label, _ButtonStyle buttonStyle) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: _CalcButton(
          label: label,
          buttonStyle: buttonStyle,
          onTap: () {
            if (label == 'DEL') {
              _backspace();
            } else {
              _append(label);
            }
          },
        ),
      ),
    );
  }
}

enum _ButtonStyle { scientific, number, operator, danger, equals }

class _CalcButton extends StatelessWidget {
  const _CalcButton({
    required this.label,
    required this.buttonStyle,
    required this.onTap,
  });

  final String label;
  final _ButtonStyle buttonStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundForStyle(buttonStyle),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Color _backgroundForStyle(_ButtonStyle style) {
    switch (style) {
      case _ButtonStyle.scientific:
        return const Color(0xFF5F7C8D);
      case _ButtonStyle.number:
        return const Color(0xFF2F2F31);
      case _ButtonStyle.operator:
        return const Color(0xFFFF981F);
      case _ButtonStyle.danger:
        return const Color(0xFFFF4C55);
      case _ButtonStyle.equals:
        return const Color(0xFF52B155);
    }
  }
}
