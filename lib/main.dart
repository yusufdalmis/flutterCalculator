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
      title: 'Scientific Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const ScientificCalculatorPage(),
    );
  }
}

class ScientificCalculatorPage extends StatefulWidget {
  const ScientificCalculatorPage({super.key});

  @override
  State<ScientificCalculatorPage> createState() => _ScientificCalculatorPageState();
}

class _ScientificCalculatorPageState extends State<ScientificCalculatorPage> {
  static const Color _scientificColor = Color(0xFF607D8B);
  static const Color _numberColor = Color(0xFF333333);
  static const Color _operatorColor = Color(0xFFFF9800);
  static const Color _actionRed = Color(0xFFF44336);
  static const Color _actionGreen = Color(0xFF4CAF50);
  static const Set<String> _operators = {'+', '-', '×', '÷', '^'};

  String equation = '0';
  String result = '0';

  void _append(String value) {
    setState(() {
      if (equation == '0') {
        if (RegExp(r'^\d$').hasMatch(value) || value == '.') {
          equation = value;
        } else if (_operators.contains(value)) {
          equation = '0$value';
        } else {
          equation = value;
        }
      } else {
        equation += value;
      }
    });
  }

  void _backspace() {
    setState(() {
      if (equation.length <= 1) {
        equation = '0';
      } else {
        equation = equation.substring(0, equation.length - 1);
      }
    });
  }

  void _clearAll() {
    setState(() {
      equation = '0';
      result = '0';
    });
  }

  void _calculate() {
    try {
      final sanitized = equation.replaceAll('×', '*').replaceAll('÷', '/');
      final parser = Parser();
      final exp = parser.parse(sanitized);
      final eval = exp.evaluate(EvaluationType.REAL, ContextModel());
      setState(() {
        result = _formatResult(eval);
      });
    } on FormatException catch (error) {
      debugPrint('Calculator format error: $error');
      setState(() {
        result = 'Error';
      });
    } on Exception catch (error) {
      debugPrint('Calculator evaluation error: $error');
      setState(() {
        result = 'Error';
      });
    }
  }

  String _formatResult(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value == value.roundToDouble()) return value.toInt().toString();
    final fixed = value.toStringAsFixed(10);
    return fixed.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.black,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scientific Calculator',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              equation,
                              key: const ValueKey('equationText'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              result,
                              key: const ValueKey('resultText'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: [
                    _buttonRow([
                      _textButton('sin(', _scientificColor, () => _append('sin(')),
                      _textButton('cos(', _scientificColor, () => _append('cos(')),
                      _textButton('tan(', _scientificColor, () => _append('tan(')),
                      _textButton('log(', _scientificColor, () => _append('log(')),
                    ]),
                    _buttonRow([
                      _textButton('sqrt(', _scientificColor, () => _append('sqrt(')),
                      _textButton('^', _scientificColor, () => _append('^')),
                      _textButton('(', _scientificColor, () => _append('(')),
                      _textButton(')', _scientificColor, () => _append(')')),
                    ]),
                    _buttonRow([
                      _textButton('7', _numberColor, () => _append('7')),
                      _textButton('8', _numberColor, () => _append('8')),
                      _textButton('9', _numberColor, () => _append('9')),
                      _textButton('÷', _operatorColor, () => _append('÷')),
                    ]),
                    _buttonRow([
                      _textButton('4', _numberColor, () => _append('4')),
                      _textButton('5', _numberColor, () => _append('5')),
                      _textButton('6', _numberColor, () => _append('6')),
                      _textButton('×', _operatorColor, () => _append('×')),
                    ]),
                    _buttonRow([
                      _textButton('1', _numberColor, () => _append('1')),
                      _textButton('2', _numberColor, () => _append('2')),
                      _textButton('3', _numberColor, () => _append('3')),
                      _textButton('-', _operatorColor, () => _append('-')),
                    ]),
                    _buttonRow([
                      _textButton('0', _numberColor, () => _append('0')),
                      _textButton('.', _numberColor, () => _append('.')),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: CustomCalcButton(
                            icon: Icons.backspace_outlined,
                            backgroundColor: _actionRed,
                            onTap: _backspace,
                          ),
                        ),
                      ),
                      _textButton('+', _operatorColor, () => _append('+')),
                    ]),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: CustomCalcButton(
                              text: 'C',
                              backgroundColor: _actionRed,
                              onTap: _clearAll,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: CustomCalcButton(
                              text: '=',
                              backgroundColor: _actionGreen,
                              onTap: _calculate,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textButton(String text, Color color, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: CustomCalcButton(
          text: text,
          backgroundColor: color,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buttonRow(List<Widget> children) {
    return Expanded(
      child: Row(children: children),
    );
  }
}

class CustomCalcButton extends StatelessWidget {
  static const double _buttonBorderRadius = 8;

  const CustomCalcButton({
    super.key,
    this.text,
    this.icon,
    required this.backgroundColor,
    this.textColor = Colors.white,
    required this.onTap,
  }) : assert(text != null || icon != null);

  final String? text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(_buttonBorderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(_buttonBorderRadius),
        onTap: onTap,
        child: Center(
          child: icon != null
              ? Icon(icon, color: textColor, size: 24)
              : Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
        ),
      ),
    );
  }
}
