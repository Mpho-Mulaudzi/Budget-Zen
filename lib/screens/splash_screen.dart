import 'package:flutter/material.dart';
import '../dialogs/ad_dialogs.dart';
import 'home_screen.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      await Future.delayed(const Duration(milliseconds: 500));
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const AdDialog(initialAd: true));
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(
        backgroundColor: Color(0xFF212121),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo(size: 120),
                SizedBox(height: 20),
                Text("BudgetZen",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                CircularProgressIndicator(color: Color(0xFF00E676))
              ]),
        ),
      );
}