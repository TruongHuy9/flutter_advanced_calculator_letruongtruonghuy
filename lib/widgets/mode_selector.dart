import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../utils/constants.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.darkSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CalculatorMode>(
              value: provider.mode,
              dropdownColor: AppColors.darkSecondary,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.lightAccent),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: CalculatorMode.values.map((CalculatorMode mode) {
                return DropdownMenuItem<CalculatorMode>(
                  value: mode,
                  child: Text(
                    mode.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (CalculatorMode? newMode) {
                if (newMode != null) {
                  provider.toggleMode(newMode);
                }
              },
            ),
          ),
        );
      },
    );
  }
}