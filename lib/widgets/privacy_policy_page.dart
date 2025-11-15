import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Privacy Policy")),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: const Text(
          "Your privacy is important to us. BudgetZen collects certain non-personal information, "
              "including device identifiers and usage patterns, only to enhance your experience "
              "and serve relevant ads through Huawei Ads. By using this app, you agree to this "
              "policy. No data is sold or shared with unauthorized parties.",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ),
    ),
  );
}