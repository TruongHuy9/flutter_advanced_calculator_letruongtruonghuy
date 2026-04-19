import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import các provider và screen
import 'providers/calculator_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/history_provider.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(
    // Using Multiple Providers Cover My App with necessary providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Bây giờ MyApp đã nằm trong Provider, nên ta có thể gọi context.watch<ThemeProvider>()
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Calculator',
      
      // Cấu hình Theme dựa trên Provider
      themeMode: themeProvider.themeMode,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      
      home: const CalculatorScreen(),
    );
  }
}