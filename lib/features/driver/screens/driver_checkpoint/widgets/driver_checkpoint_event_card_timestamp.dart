import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DriverCheckpointEventCardTimestamp extends StatelessWidget {
  const DriverCheckpointEventCardTimestamp({
    super.key,
    required this.timestamp,
    this.durasi,
  });

  final DateTime timestamp;
  final int? durasi;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.md,
              vertical: MBGSizes.sm,
            ),
            decoration: BoxDecoration(
              color: MBGColors.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              border: Border.all(color: MBGColors.info.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.clock,
                  size: MBGSizes.iconMd,
                  color: MBGColors.info,
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                Expanded(
                  child: Text(
                    DateFormat('dd MMM yyyy\nHH:mm').format(timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: MBGColors.info,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (durasi != null) ...[
          const SizedBox(width: MBGSizes.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.md,
              vertical: MBGSizes.sm,
            ),
            decoration: BoxDecoration(
              color: MBGColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              border: Border.all(
                color: MBGColors.warning.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.timer_1,
                  size: MBGSizes.iconMd,
                  color: MBGColors.warning,
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                Text(
                  '$durasi\nmenit',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MBGColors.warning,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
