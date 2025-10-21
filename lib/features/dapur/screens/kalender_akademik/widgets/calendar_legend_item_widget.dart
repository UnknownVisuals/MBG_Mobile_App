import 'package:flutter/material.dart';

/// Legend item widget for calendar
class CalendarLegendItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const CalendarLegendItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
