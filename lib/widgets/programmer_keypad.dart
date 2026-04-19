import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import 'calculator_button.dart';

class ProgrammerKeypad extends StatelessWidget {
  const ProgrammerKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Bitwise Operations & Shifts
        _buildRow(
          context,
          ['AND', 'OR', 'XOR', 'NOT', '<<', '>>'],
          List.filled(6, AppColors.btnFunction),
        ),

        // Row 2: Hex A-B + Numbers 7-9 + Div
        _buildRow(
          context,
          ['A', 'B', '7', '8', '9', '÷'],
          [
            AppColors.btnFunction, AppColors.btnFunction,
            AppColors.btnNumber, AppColors.btnNumber, AppColors.btnNumber,
            AppColors.btnOperator
          ],
        ),

        // Row 3: Hex C-D + Numbers 4-6 + Mul
        _buildRow(
          context,
          ['C', 'D', '4', '5', '6', '×'],
          [
            AppColors.btnFunction, AppColors.btnFunction,
            AppColors.btnNumber, AppColors.btnNumber, AppColors.btnNumber,
            AppColors.btnOperator
          ],
        ),

        // Row 4: Hex E-F + Numbers 1-3 + Sub
        _buildRow(
          context,
          ['E', 'F', '1', '2', '3', '-'],
          [
            AppColors.btnFunction, AppColors.btnFunction,
            AppColors.btnNumber, AppColors.btnNumber, AppColors.btnNumber,
            AppColors.btnOperator
          ],
        ),

        // Row 5: Clear, 0, Double Zero, Equal, Add
        _buildRow(
          context,
          ['C', 'CE', '0', '00', '=', '+'],
          [
            AppColors.btnFunction, AppColors.btnFunction,
            AppColors.btnNumber, AppColors.btnNumber,
            AppColors.lightAccent, AppColors.btnOperator
          ],
          textColors: [
             AppColors.lightAccent, AppColors.lightAccent,
             Colors.white, Colors.white, Colors.white, Colors.white
          ]
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
                // --- Programmer Operators ---
                case 'AND':
                case 'OR':
                case 'XOR':
                case 'NOT':
                case '<<':
                case '>>':
                   provider.addToExpression(' $label '); 
                   break;
                default:
                   provider.addToExpression(label);
                   break;
              }
            },
          );
        }),
      ),
    );
  }
}