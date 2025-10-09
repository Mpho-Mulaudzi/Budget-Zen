import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({required this.size, super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
        color: const Color(0xFF00E676),
        borderRadius: BorderRadius.circular(size)),
    child: Center(
        child: Text("Z",
            style: TextStyle(
                color: const Color(0xFF212121),
                fontSize: size * 0.6,
                fontWeight: FontWeight.w900))),
  );
}