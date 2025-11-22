import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurDashboardTodayMenuCard extends StatelessWidget {
  const DapurDashboardTodayMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
            ),
            child: const Icon(Iconsax.note, color: Colors.green),
          ),

          const SizedBox(width: MBGSizes.spaceBtwItems),

          // Menu Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nasi Box Spesial',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '08:00 - 09:00 WIB',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: MBGSizes.spaceBtwItems / 2),

          // Price Tag
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.md,
              vertical: MBGSizes.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
            ),
            child: Text(
              'Rp ${NumberFormat('#,###').format(15000)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
