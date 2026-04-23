import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final int flex; // For buttons that need to span multiple columns

  const CalculatorButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.onTap,
    this.textColor = Colors.white,
    this.flex = 1,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: text.length > 2 ? 20 : 28, //  giảm size cho AND, XOR
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
