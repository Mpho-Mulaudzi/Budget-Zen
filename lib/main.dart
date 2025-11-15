import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'theme_provider.dart';
import 'language_provider.dart';
import 'package:budget_zen/widgets/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const BudgetZenApp(),
    ),
  );
}

class BudgetZenApp extends StatelessWidget {
  const BudgetZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudgetZen',
      theme: themeProvider.themeData,
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
        Locale('hi'),
        Locale('es'),
        Locale('fr'),
      ],
      home: const SplashScreen(),
    );
  }
}