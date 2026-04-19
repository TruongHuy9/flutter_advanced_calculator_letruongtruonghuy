// Defines a model for storing calculation history entries.
class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  // Converts the CalculationHistory instance to a map for easy storage.
  Map<String, dynamic> toMap() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Creates a CalculationHistory instance from a map.
  factory CalculationHistory.fromMap(Map<String, dynamic> map) {
    return CalculationHistory(
      expression: map['expression'] ?? '',
      result: map['result'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}