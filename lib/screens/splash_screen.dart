import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80DED9), Color(0xFF068D9D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeIn,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(size: 120),
                const SizedBox(height: 20),
                Text(
                  loc.appName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}