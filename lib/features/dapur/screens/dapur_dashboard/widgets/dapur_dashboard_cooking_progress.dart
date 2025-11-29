import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurDashboardCookingProgress extends StatelessWidget {
  const DapurDashboardCookingProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    final int progress = 85;

    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        color: isDarkMode ? MBGColors.dark : MBGColors.light,
        border: Border.all(
          color: isDarkMode
              ? MBGColors.lightGrey.withValues(alpha: 0.4)
              : MBGColors.darkGrey.withValues(alpha: 0.4),
        ),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.timer_1, color: MBGColors.primary),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Text(
                'Today\'s Cooking Progress',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                  child: LinearProgressIndicator(
                    value: (progress / 100).clamp(0.0, 1.0),
                    minHeight: MBGSizes.md,
                    backgroundColor: isDarkMode
                        ? MBGColors.darkerGrey
                        : MBGColors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 80
                          ? Colors.green
                          : progress >= 50
                          ? Colors.orange
                          : MBGColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems),
              Text('$progress%', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          Text(
            '✓ 2 menus today',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
          ),
          Text(
            '✓ 2 checkpoints completed',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
