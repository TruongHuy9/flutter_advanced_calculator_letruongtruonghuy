import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import Provider
import 'package:flutter_advanced_calculator/providers/calculator_provider.dart';
// Import Model
import 'package:flutter_advanced_calculator/models/calculator_mode.dart';
// Import Widgets
import '../widgets/basic_keypad.dart';
import '../widgets/programmer_keypad.dart';
import '../widgets/scientific_keypad.dart';
import '../widgets/mode_selector.dart';
import '../widgets/top_action_bar.dart';
// Import Theme and Colors
import '../utils/constants.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Select current mode from provider
    final mode = context.select((CalculatorProvider p) => p.mode);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ModeSelector(),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RightNavigation(),
                  ),
                ),
              ],
            ),

            Expanded(
              flex: 35,
              child: Container(
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(
                  color: AppColors.darkSecondary,

                  borderRadius: BorderRadius.circular(24),
                ),

                padding: const EdgeInsets.all(20),

                child: Consumer<CalculatorProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        // HISTORY
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: provider.history.take(2).map((item) {
                            return GestureDetector(
                              onTap: () {
                                context.read<CalculatorProvider>()
                                    .useHistory(item.expression);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  "${item.expression} = ${item.result}",
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          provider.expression,
                          style: const TextStyle(fontSize: 24),
                        ),

                        FittedBox(
                          alignment: Alignment.centerRight,
                          child: Text(
                            provider.previewResult,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            //Keypad Area [Have change if select different mode]
            Expanded(
              flex: 65,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _getKeypadWidget(mode),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Using Helper method to get the appropriate keypad widget based on mode
  Widget _getKeypadWidget(CalculatorMode mode) {
    switch (mode) {
      case CalculatorMode.basic:
        return const BasicKeypad(key: ValueKey('basic'));
      case CalculatorMode.scientific:
        return const ScientificKeypad(key: ValueKey('scientific'));
      case CalculatorMode.programmer:
        return const ProgrammerKeypad(key: ValueKey('programmer'));
    }
  }
}