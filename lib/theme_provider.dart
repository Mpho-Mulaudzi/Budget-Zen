import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
  }

  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  // ================================================================
  //                          LIGHT THEME
  // ================================================================
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    scaffoldBackgroundColor: const Color(0xFFFdfdfd),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF068D9D),
      secondary: Color(0xFF53599A),
      tertiary: Color(0xFF80DED9),
      surface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF068D9D),
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    cardColor: Colors.white,

    // Ensures dialogs match light theme
    dialogBackgroundColor: Colors.white,

    // Ensures bottom sheets match light theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      modalBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
    ),
  );

  // ================================================================
  //                          DARK THEME
  // ================================================================
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: const Color(0xFF1C1C1E),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF80DED9),
      secondary: Color(0xFF068D9D),
      tertiary: Color(0xFF53599A),
      surface: Color(0xFF2B2B2B),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2B2B2B),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    cardColor: const Color(0xFF2B2B2B),

    // ⭐ FIX: Ensures dialogs (Add Expense, Add Income) match DARK THEME
    dialogBackgroundColor: const Color(0xFF2B2B2B),

    // ⭐ FIX: Ensures modal bottom sheets (About, Privacy Policy) match DARK THEME
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF2B2B2B),
      modalBackgroundColor: Color(0xFF2B2B2B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
    ),
  );
}
