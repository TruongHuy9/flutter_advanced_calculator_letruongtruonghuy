import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import 'calculator_button.dart';

class BasicKeypad extends StatelessWidget {
  const BasicKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: C, CE, %, ÷
        _buildRow(context, ['C', 'CE', '%', '÷'], 
            [AppColors.btnFunction, AppColors.btnFunction, AppColors.btnFunction, AppColors.btnOperator]),
        
        // Row 2: 7, 8, 9, ×
        _buildRow(context, ['7', '8', '9', '×'], 
            [AppColors.btnNumber, AppColors.btnNumber, AppColors.btnNumber, AppColors.btnOperator]),
        
        // Row 3: 4, 5, 6, -
        _buildRow(context, ['4', '5', '6', '-'], 
            [AppColors.btnNumber, AppColors.btnNumber, AppColors.btnNumber, AppColors.btnOperator]),
        
        // Row 4: 1, 2, 3, +
        _buildRow(context, ['1', '2', '3', '+'], 
            [AppColors.btnNumber, AppColors.btnNumber, AppColors.btnNumber, AppColors.btnOperator]),
        
        // Row 5: ±, 0, ., =
        _buildRow(context, ['+/-', '0', '.', '='], 
            [AppColors.btnNumber, AppColors.btnNumber, AppColors.btnNumber, AppColors.lightAccent]), 
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> labels, List<Color> bgColors) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(labels.length, (index) {
          final label = labels[index];
          return CalculatorButton(
            text: label,
            bgColor: bgColors[index],
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
                case '+/-':
                   provider.addToExpression('-'); 
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