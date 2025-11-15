import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const BudgetZenApp(),
    ),
  );
}

class BudgetZenApp extends StatelessWidget {
  const BudgetZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudgetZen',
      theme: themeProvider.themeData,
      home: const SplashScreen(),
    );
  }
}