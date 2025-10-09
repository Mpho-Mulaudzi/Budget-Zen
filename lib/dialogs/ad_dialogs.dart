import 'dart:async';
import 'package:flutter/material.dart';

class AdDialog extends StatefulWidget {
  final bool initialAd;
  const AdDialog({this.initialAd = false, super.key});
  @override
  State<AdDialog> createState() => _AdDialogState();
}

class _AdDialogState extends State<AdDialog> {
  int seconds = 0;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => seconds = t.tick);
      if (seconds >= 10) t.cancel();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canClose = seconds >= 10;
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.campaign, size: 100, color: Colors.white),
            const SizedBox(height: 15),
            Text(widget.initialAd ? "Welcome Ad" : "Sponsored Ad",
                style: const TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 10),
            Text("Time: $seconds / 14 seconds",
                style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 20),
            if (canClose)
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676)),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black),
                  label: const Text("Close Ad",
                      style: TextStyle(color: Colors.black)))
          ]),
        ));
  }
}