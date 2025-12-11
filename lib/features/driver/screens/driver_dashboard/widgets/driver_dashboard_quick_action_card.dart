import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DriverDashboardQuickActionCard extends StatelessWidget {
  const DriverDashboardQuickActionCard({
    super.key,
    this.title = 'Scan QR Code',
    this.subtitle = 'Scan delivery QR untuk memperbarui status',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MBGSizes.lg,
        vertical: MBGSizes.md,
      ),
      decoration: BoxDecoration(
        gradient: MBGColors.primaryGradient,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: MBGColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
            decoration: BoxDecoration(
              color: MBGColors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            ),
            child: Icon(
              Iconsax.scan_barcode,
              color: MBGColors.white,
              size: MBGSizes.iconLg,
            ),
          ),
          const SizedBox(width: MBGSizes.spaceBtwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MBGColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: MBGColors.textWhite),
                ),
              ],
            ),
          ),
          const Icon(
            Iconsax.arrow_right_3,
            color: MBGColors.textWhite,
            size: MBGSizes.iconMd,
          ),
        ],
      ),
    );
  }
}
