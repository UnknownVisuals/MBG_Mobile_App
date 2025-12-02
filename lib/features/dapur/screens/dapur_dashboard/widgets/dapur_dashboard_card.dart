import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurDashboardCard extends StatelessWidget {
  const DapurDashboardCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        color: isDarkMode
            ? color.withValues(alpha: 0.15)
            : color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(
          color: isDarkMode
              ? color.withValues(alpha: 0.6)
              : color.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(icon, color: color, size: MBGSizes.iconLg),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
