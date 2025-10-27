import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

/// Nutrition info widget displaying nutritional values
class MenuPlanningNutritionInfoWidget extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final IconData icon;

  const MenuPlanningNutritionInfoWidget({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: MBGColors.primary),
        const SizedBox(height: MBGSizes.xs),
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
          ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
