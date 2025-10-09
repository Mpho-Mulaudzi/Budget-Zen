import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const BudgetZenApp());

class BudgetZenApp extends StatelessWidget {
  const BudgetZenApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "BudgetZen",
    home: SplashScreen(),
  );
}


