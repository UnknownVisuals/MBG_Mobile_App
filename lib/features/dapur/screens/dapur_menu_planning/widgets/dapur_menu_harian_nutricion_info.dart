import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Nutrition info widget displaying nutritional values
class DapurMenuHarianNutricionInfo extends StatelessWidget {
  const DapurMenuHarianNutricionInfo({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  final String label;
  final double value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: MBGSizes.iconMd, color: MBGColors.primary),
        Text(
          '${value.toStringAsFixed(1)}$unit',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: MBGColors.textSecondary),
        ),
      ],
    );
  }
}
