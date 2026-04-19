import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_advanced_calculator/providers/calculator_provider.dart';
import 'package:flutter_advanced_calculator/models/calculator_mode.dart';

void main() {
  late CalculatorProvider provider;

  setUp(() {
    provider = CalculatorProvider();
  });

  group('Basic Calculation Tests', () {
    test('Cộng trừ nhân chia cơ bản', () {
      // Test: 2 + 3 × 4
      provider.addToExpression('2');
      provider.addToExpression('+');
      provider.addToExpression('3');
      provider.addToExpression('*');
      provider.addToExpression('4');
      
      provider.calculate();
      
      // Expected: 2 + 12 = 14
      expect(provider.result, '14');
    });

    test('Xử lý biểu thức có ngoặc', () {
      // Test: ( 2 + 3 ) × 2
      provider.addToExpression('(');
      provider.addToExpression('2');
      provider.addToExpression('+');
      provider.addToExpression('3');
      provider.addToExpression(')');
      provider.addToExpression('*');
      provider.addToExpression('2');
      
      provider.calculate();
      
      // Expected: 5 * 2 = 10
      expect(provider.result, '10');
    });

    test('Xử lý số thập phân', () {
      provider.addToExpression('2.5');
      provider.addToExpression('*');
      provider.addToExpression('2');
      
      provider.calculate();
      
      expect(provider.result, '5');
    });
  });

  group('Scientific Mode Tests', () {
    test('Tính bình phương (x²)', () {
      provider.addToExpression('4');
      provider.addToExpression('^2');

      provider.calculate();
      
      expect(provider.result, '16');
    });

    test('Tự động đóng ngoặc khi thiếu', () {
      // Input: sin(0
      // Logic autocorrect: sin(0)
      provider.addToExpression('sin(');
      provider.addToExpression('0');
      
      provider.calculate();
      
      expect(provider.result, '0');
    });
  });

  group('Programmer Mode Tests', () {
    test('Chuyển đổi mode sang Programmer', () {
      provider.toggleMode(CalculatorMode.programmer);
      expect(provider.mode, CalculatorMode.programmer);
    });

    test('Phép cộng Hex (A + B)', () {
      provider.toggleMode(CalculatorMode.programmer);
      
      provider.addToExpression('A'); // 10
      provider.addToExpression('+');
      provider.addToExpression('B'); // 11
      
      provider.calculate();
      
      // Expected: 10 + 11 = 21 -> Hex is 15
      expect(provider.result, '15'); 
    });

    test('Phép AND Bitwise (A AND B)', () {
      provider.toggleMode(CalculatorMode.programmer);
      
      // A = 1010, B = 1011
      // A & B = 1010 = A (Hex)
      provider.addToExpression('A');
      provider.addToExpression('AND');
      provider.addToExpression('B');
      
      provider.calculate();
      
      expect(provider.result, 'A');
    });
  });

  group('Memory & Error Tests', () {
    test('Xóa ký tự (Backspace)', () {
      provider.addToExpression('123');
      provider.delete();
      expect(provider.expression, '12');
    });

    test('Clear All (AC)', () {
      provider.addToExpression('123');
      provider.clear();
      expect(provider.expression, '');
      expect(provider.result, '0');
    });

    test('Chia cho 0 báo lỗi hoặc Infinity', () {
      provider.addToExpression('5');
      provider.addToExpression('/');
      provider.addToExpression('0');
      
      provider.calculate();
      expect(provider.result, 'Error'); 
    });
  });
}