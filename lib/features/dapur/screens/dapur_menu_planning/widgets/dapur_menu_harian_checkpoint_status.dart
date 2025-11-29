import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Checkpoint status widget displaying checkpoint badges
class DapurMenuHarianCheckpointStatus extends StatelessWidget {
  const DapurMenuHarianCheckpointStatus({super.key, required this.checkpoints});

  final List<DapurMenuHarianCheckpointSummary> checkpoints;

  @override
  Widget build(BuildContext context) {
    // Only show if checkpoints exist
    if (checkpoints.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: MBGSizes.spaceBtwItems),
        const Divider(),
        const SizedBox(height: MBGSizes.spaceBtwItems / 2),
        Row(
          children: [
            const Icon(
              Iconsax.task_square,
              size: MBGSizes.iconSm,
              color: MBGColors.textSecondary,
            ),
            const SizedBox(width: MBGSizes.xs),
            Text(
              'Checkpoint Status:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: MBGColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: MBGSizes.sm),
        Wrap(
          spacing: MBGSizes.xs,
          runSpacing: MBGSizes.xs,
          children: checkpoints
              .where((checkpoint) => checkpoint.tipe!.isNotEmpty)
              .map((checkpoint) {
                // Format checkpoint type for display
                final displayText = checkpoint.tipe!.replaceAll('_', ' ');

                // Determine color based on checkpoint type
                final Color badgeColor;
                final IconData badgeIcon;

                switch (checkpoint.tipe) {
                  case 'MULAI_MEMASAK':
                    badgeColor = MBGColors.primary;
                    badgeIcon = Iconsax.play_circle;
                    break;
                  case 'SELESAI_MEMASAK':
                    badgeColor = MBGColors.success;
                    badgeIcon = Iconsax.tick_circle;
                    break;
                  case 'SELESAI_PACKING':
                    badgeColor = MBGColors.info;
                    badgeIcon = Iconsax.box_tick;
                    break;
                  case 'SCHOOL_TO_DRIVER_RETURN':
                    badgeColor = MBGColors.warning;
                    badgeIcon = Iconsax.arrow_left;
                    break;
                  case 'DRIVER_TO_KITCHEN':
                    badgeColor = MBGColors.primary;
                    badgeIcon = Iconsax.truck_fast;
                    break;
                  case 'KITCHEN_RECEIVED':
                    badgeColor = MBGColors.success;
                    badgeIcon = Iconsax.receipt_item;
                    break;
                  case 'WASHING_COMPLETE':
                    badgeColor = MBGColors.info;
                    badgeIcon = Iconsax.check;
                    break;
                  default:
                    badgeColor = MBGColors.darkGrey;
                    badgeIcon = Iconsax.record_circle;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MBGSizes.sm,
                    vertical: MBGSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusSm,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, size: 14, color: badgeColor),
                      const SizedBox(width: MBGSizes.xs),
                      Text(
                        displayText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              })
              .toList(),
        ),
      ],
    );
  }
}
