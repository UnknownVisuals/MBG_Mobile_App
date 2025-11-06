import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DriverDashboardStatsRow extends StatelessWidget {
  const DriverDashboardStatsRow({
    super.key,
    required this.pending,
    required this.complete,
  });

  final int pending;
  final int complete;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        icon: Iconsax.truck,
        label: 'Sedang Diantar',
        value: pending.toString(),
        color: MBGColors.warning,
      ),
      (
        icon: Iconsax.tick_circle,
        label: 'Selesai Hari Ini',
        value: complete.toString(),
        color: MBGColors.success,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(MBGSizes.md),
              decoration: BoxDecoration(
                color: stats[i].color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
                border: Border.all(
                  color: stats[i].color.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    stats[i].icon,
                    color: stats[i].color,
                    size: MBGSizes.iconLg,
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  Text(
                    stats[i].value,
                    style: TextStyle(
                      fontSize: MBGSizes.fontSizeLg + 2,
                      fontWeight: FontWeight.bold,
                      color: stats[i].color,
                    ),
                  ),
                  Text(
                    stats[i].label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: MBGSizes.fontSizeSm,
                      color: MBGColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i < stats.length - 1)
            const SizedBox(width: MBGSizes.spaceBtwItems),
        ],
      ],
    );
  }
}
