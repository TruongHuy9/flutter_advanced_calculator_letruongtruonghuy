import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../models/calculator_mode.dart';
import '../models/calculation_history.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AngleMode { degrees, radians }

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  AngleMode get angleMode => _angleMode;  
  final List<CalculationHistory> _history = [];
  double _memory = 0.0;

  // Getters
  String get expression => _expression;
  String get result => _result;
  CalculatorMode get mode => _mode;
  // AngleMode get angleMode => _angleMode;
  List<CalculationHistory> get history => _history;

String get previewResult {
  if (_expression.isEmpty) return '0';

  if (_mode == CalculatorMode.programmer) {
    // Mode programmer khó preview full → giữ result cũ
    return _result;
  }

  String _applyAngleMode(String expr) {
  if (_angleMode == AngleMode.radians) return expr;

  return expr
      .replaceAllMapped(RegExp(r'sin\(([^()]+)\)'), (m) =>
          'sin((${m[1]}) * ${math.pi}/180)')
      .replaceAllMapped(RegExp(r'cos\(([^()]+)\)'), (m) =>
          'cos((${m[1]}) * ${math.pi}/180)')
      .replaceAllMapped(RegExp(r'tan\(([^()]+)\)'), (m) =>
          'tan((${m[1]}) * ${math.pi}/180)');
}

  try {
    String finalExpression = _cleanExpression(_expression);
    finalExpression = _autoCloseParentheses(finalExpression);
    finalExpression = _applyAngleMode(finalExpression);

    // Nếu kết thúc bằng toán tử → bỏ đi
    if (finalExpression.isNotEmpty &&
        _isOperator(finalExpression.characters.last)) {
      finalExpression =
          finalExpression.substring(0, finalExpression.length - 1);
    }

    if (finalExpression.isEmpty) return '0';

    Parser p = Parser();
    Expression exp = p.parse(finalExpression);
    ContextModel cm = ContextModel();
    //  áp dụng DEG/RAD
double eval = exp.evaluate(EvaluationType.REAL, cm);

    if (eval.isInfinite || eval.isNaN) return 'Error';

    return NumberFormat("#.##########", "en_US").format(eval);
  } catch (e) {
    return _result; // fallback nếu đang nhập dang dở
  }
}

  Future<void> saveAngleMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('angleMode', _angleMode.toString());
  }

  void setAngleMode(AngleMode mode) {
    _angleMode = mode;
    saveAngleMode(); // lưu lại
    notifyListeners();
  }

  void useHistory(String expr) {
    _expression = expr;
    calculate();
    notifyListeners();
  }
  // --- INPUT HANDLING ---
  void addToExpression(String value) {
    if (_mode == CalculatorMode.programmer) {
      // Logic Exception For Programmer Mode
       _expression += value;
    } else {
      // Logic Scientific/Basic
      if (['sin', 'cos', 'tan', 'log', 'ln', 'sqrt'].contains(value)) {
        _expression += '$value(';
      } else if (value == '√') {
        _expression += '√(';
      } else if (value == 'x²') {
        _expression += '^2';
      } else if (value == 'x^y') {
        _expression += '^';
      } else {
        _expression += value;
      }
    }
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '0';
    notifyListeners();
  }

  void delete() {
    if (_expression.isNotEmpty) {
      // Delete last character or function
      if (_expression.endsWith(" ")) {
        _expression = _expression.trimRight();
      }
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  // --- MAIN CALCULATION ROUTER ---
  
  void calculate() {
    if (_expression.isEmpty) return;

    if (_mode == CalculatorMode.programmer) {
      _calculateProgrammer();
    } else {
      _calculateScientific();
    }
    notifyListeners();
  }

  // --- LOGIC SCIENTIFIC (Using Library) ---

    void _calculateScientific() {
      try {
        String finalExpression = _cleanExpression(_expression);

        // ✅ auto đóng ngoặc
        finalExpression = _autoCloseParentheses(finalExpression);

        // ✅ nếu kết thúc bằng toán tử → bỏ
        if (finalExpression.isNotEmpty &&
            _isOperator(finalExpression.characters.last)) {
          finalExpression =
              finalExpression.substring(0, finalExpression.length - 1);
        }

        //  FIX QUAN TRỌNG: nếu chỉ có "(" hoặc rỗng
        if (finalExpression.trim().isEmpty || finalExpression == "()") {
          _result = "0";
          return;
        }

        Parser p = Parser();
        Expression exp = p.parse(finalExpression);
        ContextModel cm = ContextModel();

        double eval = exp.evaluate(EvaluationType.REAL, cm);

        if (eval.isInfinite || eval.isNaN) {
          _result = "Error";
        } else {
          _result = NumberFormat("#.##########", "en_US").format(eval);
          _addToHistory(_expression, _result);
        }
      } catch (e) {
        debugPrint("Sci Error: $e");
        _result = "Error";
      }
    }
    String _applyAngleMode(String expr) {
  if (_angleMode == AngleMode.radians) return expr;

  return expr
      .replaceAllMapped(RegExp(r'sin\(([^()]+)\)'), (m) =>
          'sin((${m[1]}) * ${math.pi}/180)')
      .replaceAllMapped(RegExp(r'cos\(([^()]+)\)'), (m) =>
          'cos((${m[1]}) * ${math.pi}/180)')
      .replaceAllMapped(RegExp(r'tan\(([^()]+)\)'), (m) =>
          'tan((${m[1]}) * ${math.pi}/180)');
}

  // --- LOGIC PROGRAMMER (Manual) ---

  void _calculateProgrammer() {
    try {

      String expr = _expression;
      
      final operators = ['+', '-', '×', '÷', 'AND', 'OR', 'XOR', '<<', '>>'];
      String? op;
      
      for (var o in operators) {
        if (expr.contains(o)) {
          op = o;
          break;
        }
      }

      if (op != null) {
        List<String> parts = expr.split(op);
        if (parts.length == 2) {
          int num1 = int.parse(parts[0].trim(), radix: 16);
          int num2 = int.parse(parts[1].trim(), radix: 16);
          int resInt = 0;

          switch (op) {
            case '+': resInt = num1 + num2; break;
            case '-': resInt = num1 - num2; break;
            case '×': resInt = num1 * num2; break;
            case '÷': resInt = num1 ~/ num2; break; // Division integer
            case 'AND': resInt = num1 & num2; break;
            case 'OR': resInt = num1 | num2; break;
            case 'XOR': resInt = num1 ^ num2; break;
            case '<<': resInt = num1 << num2; break;
            case '>>': resInt = num1 >> num2; break;
          }
          
          _result = resInt.toRadixString(16).toUpperCase();
          _addToHistory(_expression, _result);
        }
      } else {
        int val = int.parse(expr.trim(), radix: 16);
        _result = val.toRadixString(16).toUpperCase();
      }

    } catch (e) {
      debugPrint("Prog Error: $e");
      _result = "Error";
    }
  }

  // --- HELPER METHODS ---

  String _cleanExpression(String input) {
    String cleaned = input;
    cleaned = cleaned.replaceAll('×', '*');
    cleaned = cleaned.replaceAll('÷', '/');
    //  fix nhân ngầm: 2pi → 2*pi
    //  nhân ngầm: 2cos(30), 3sin(45)
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(\d)(sin|cos|tan|log|ln|sqrt)\('),
      (m) => '${m[1]}*${m[2]}(',
    );

    //  nhân ngầm: )(
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'\)\('),
      (m) => ')*(',
    );

    //  nhân ngầm: )2
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'\)(\d)'),
      (m) => ')*${m[1]}',
    );
    cleaned = cleaned.replaceAllMapped(
    RegExp(r'(\d)(π|e)'),
    (m) => '${m[1]}*${m[2]}',
    );

    // π2 hoặc e2
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(π|e)(\d)'),
      (m) => '${m[1]}*${m[2]}',
    );

    // 2(3+4)
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(\d)\('),
      (m) => '${m[1]}*(',
    );
    cleaned = cleaned.replaceAll('π', math.pi.toString());
    cleaned = cleaned.replaceAll('e', math.e.toString());
    //  fix nhân ngầm: 2pi → 2*pi
    // 2π hoặc 2e

    cleaned = cleaned.replaceAll('√', 'sqrt'); 
    cleaned = cleaned.replaceAll('%', '/100');

    
    return cleaned;
  }

  String _autoCloseParentheses(String text) {
    int open = '('.allMatches(text).length;
    int close = ')'.allMatches(text).length;
    if (open > close) return text + ')' * (open - close);
    return text;
  }

  bool _isOperator(String char) {
    return ['+', '-', '*', '/', '^', '.'].contains(char);
  }

  void _addToHistory(String eq, String res) {
    _history.insert(0, CalculationHistory(
      expression: eq, 
      result: res, 
      timestamp: DateTime.now()
    ));
    if (_history.length > 50) _history.removeLast();
  }

  // --- SETTERS & TOGGLES ---
  void toggleMode(CalculatorMode newMode) { 
    _mode = newMode; 
    clear();
    notifyListeners(); 
  }
  
  void memoryClear() { _memory = 0.0; notifyListeners(); }
  void memoryAdd() { try { _memory += double.parse(_result); notifyListeners(); } catch (e) {} }
  void memorySubtract() { try { _memory -= double.parse(_result); notifyListeners(); } catch (e) {} }
  void memoryRecall() { 
     String val = _memory % 1 == 0 ? _memory.toInt().toString() : _memory.toString();
     addToExpression(val);
  }
}

extension StringExtension on String {
  String get lastAsString => isEmpty ? '' : this[length - 1];
}
