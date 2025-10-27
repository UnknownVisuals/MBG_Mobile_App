import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurDashboardCookingProgress extends StatelessWidget {
  const DapurDashboardCookingProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurDashboardController controller = Get.put(
      DapurDashboardController(),
    );

    final progress = controller.getCookingProgress();

    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        color: MBGColors.light,
        border: Border.all(color: MBGColors.grey),
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
                    value: progress / 100,
                    minHeight: MBGSizes.md,
                    backgroundColor: MBGColors.grey,
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
              Text(
                '${progress.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          Text(
            '✓ ${controller.todaysMenus.length} menus today',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
          ),
          Text(
            '✓ ${controller.completedCheckpointsToday.value} checkpoints completed',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
