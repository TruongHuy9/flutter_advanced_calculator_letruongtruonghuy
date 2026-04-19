import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import 'calculator_button.dart';

class ScientificKeypad extends StatelessWidget {
  const ScientificKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: 2nd, sin, cos, tan, ln, log
        _buildRow(
          context,
          ['2nd', 'sin', 'cos', 'tan', 'ln', 'log'],
          List.filled(6, AppColors.btnFunction),
        ),
        
        // Row 2: x², √, x^y, (, ), ÷
        _buildRow(
          context,
          ['x²', '√', 'x^y', '(', ')', '÷'],
          [
            AppColors.btnFunction, AppColors.btnFunction, AppColors.btnFunction,
            AppColors.btnFunction, AppColors.btnFunction, AppColors.btnOperator
          ],
        ),

        // Row 3: MC, 7, 8, 9, C, ×
        _buildRow(
          context,
          ['MC', '7', '8', '9', 'C', '×'],
          [
            AppColors.btnFunction, AppColors.btnNumber, AppColors.btnNumber,
            AppColors.btnNumber, AppColors.btnFunction, AppColors.btnOperator
          ],
          textColors: [Colors.white, Colors.white, Colors.white, Colors.white, AppColors.lightAccent, Colors.white]
        ),

        // Row 4: MR, 4, 5, 6, CE, -
        _buildRow(
          context,
          ['MR', '4', '5', '6', 'CE', '-'],
          [
            AppColors.btnFunction, AppColors.btnNumber, AppColors.btnNumber,
            AppColors.btnNumber, AppColors.btnFunction, AppColors.btnOperator
          ],
          textColors: [Colors.white, Colors.white, Colors.white, Colors.white, AppColors.lightAccent, Colors.white]
        ),

        // Row 5: M+, 1, 2, 3, %, +
        _buildRow(
          context,
          ['M+', '1', '2', '3', '%', '+'],
          [
            AppColors.btnFunction, AppColors.btnNumber, AppColors.btnNumber,
            AppColors.btnNumber, AppColors.btnFunction, AppColors.btnOperator
          ],
        ),

        // Row 6: M-, ±, 0, ., π, =
        _buildRow(
          context,
          ['M-', '±', '0', '.', 'π', '='],
          [
            AppColors.btnFunction, AppColors.btnNumber, AppColors.btnNumber,
            AppColors.btnNumber, AppColors.btnFunction, AppColors.lightAccent
          ],
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> labels, List<Color> bgColors, {List<Color>? textColors}) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(labels.length, (index) {
          final label = labels[index];
          return CalculatorButton(
            text: label,
            bgColor: bgColors[index],
            textColor: textColors != null ? textColors[index] : Colors.white,
            onTap: () {
              final provider = Provider.of<CalculatorProvider>(context, listen: false);

              switch (label) {
                case 'C':
                  provider.clear();
                  break;
                case 'CE':
                  provider.delete();
                  break;
                case '=':
                  provider.calculate();
                  if (provider.result != 'Error') {
                    Provider.of<HistoryProvider>(context, listen: false)
                        .addHistory(provider.expression, provider.result);
                  }
                  break;
                // --- Memory ---
                case 'MC': provider.memoryClear(); break;
                case 'MR': provider.memoryRecall(); break;
                case 'M+': provider.memoryAdd(); break;
                case 'M-': provider.memorySubtract(); break;
                case '2nd': 
                  break;
                case '±': provider.addToExpression('-'); break;
                default: provider.addToExpression(label); break;
              }
            },
          );
        }),
      ),
    );
  }
}