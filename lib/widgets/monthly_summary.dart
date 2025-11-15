import 'dart:math';
import 'package:flutter/material.dart';

class MonthlySummary extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  final String currency;

  const MonthlySummary(
      {super.key, required this.expenses, required this.currency});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const SizedBox();
    }

    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.light
        ? theme.colorScheme.secondary
        : Colors.white70;

    final grouped = <String, double>{};
    for (final e in expenses) {
      grouped[e["category"]] =
          (grouped[e["category"]] ?? 0) + (e["amount"] as double);
    }
    final total = grouped.values.fold(0.0, (a, b) => a + b);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 8),
      ...grouped.entries.map((e) {
        final percent = (e.value / total) * 100;
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Expanded(
                  flex: e.value.round(),
                  child: Container(
                      height: 8,
                      color: Colors
                          .primaries[e.key.length % Colors.primaries.length])),
              const SizedBox(width: 8),
              Text(
                  "${e.key} $currency${e.value.toStringAsFixed(0)} (${percent.toStringAsFixed(1)}%)",
                  style: TextStyle(color: textColor))
            ]));
      }),
      const SizedBox(height: 20),
      SizedBox(
          height: 160,
          child: CustomPaint(
              painter: _DonutPainter(
                grouped: grouped,
                total: total,
                isDark: theme.brightness == Brightness.dark,
              ),
              child: const SizedBox.expand())),
      const SizedBox(height: 20)
    ]);
  }
}

class _DonutPainter extends CustomPainter {
  final Map<String, double> grouped;
  final double total;
  final bool isDark;

  _DonutPainter({
    required this.grouped,
    required this.total,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;
    double start = -pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;

    final colors = Colors.primaries;
    int i = 0;
    for (final entry in grouped.entries) {
      final sweep = (entry.value / total) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          start, sweep, false, paint);
      start += sweep;
      i++;
    }

    // inner hole - adapts to theme
    canvas.drawCircle(
      center,
      radius / 2.2,
      Paint()..color = isDark ? const Color(0xFF212121) : Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}