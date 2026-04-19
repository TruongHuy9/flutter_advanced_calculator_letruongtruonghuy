import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';

class HistoryProvider extends ChangeNotifier {
  List<CalculationHistory> _history = [];

  // Getter
  List<CalculationHistory> get history => _history;

  // Key using store in SharedPreferences
  static const String _historyKey = 'calc_history';

  // --- Create and load data ---
  HistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_historyKey);

    if (historyJson != null) {
      // Decode JSON thành List<Map> rồi map sang List<CalculationHistory>
      final List<dynamic> decoded = jsonDecode(historyJson);
      _history = decoded
          .map((item) => CalculationHistory.fromMap(item))
          .toList();
      notifyListeners();
    }
  }

  // --- Store Data ---
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert List<Object> -> List<Map> -> JSON String
    final String encoded = jsonEncode(_history.map((e) => e.toMap()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  void addHistory(String expression, String result) {
    if (result == 'Error') return;

    final newItem = CalculationHistory(
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );

    _history.insert(0, newItem);

    // Limited to 50 items
    if (_history.length > 50) {
      _history.removeLast();
    }

    _saveHistory();
    notifyListeners();
  }

  // --- Clear History ---
  void clearHistory() async {
    _history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    notifyListeners();
  }

  // Add in HistoryProvider
  void removeItem(int index) {
    _history.removeAt(index);
    _saveHistory();
    notifyListeners();
  }
}