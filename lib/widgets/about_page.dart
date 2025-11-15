import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("About BudgetZen")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppLogo(size: 100),
            const SizedBox(height: 16),
            Text("BudgetZen",
                style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary)),
            const SizedBox(height: 10),
            const Text("Version 1.2.0",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text(
              "BudgetZen helps you track expenses and maintain financial mindfulness. "
                  "Built with Flutter, integrating Huawei Ads to support development.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}