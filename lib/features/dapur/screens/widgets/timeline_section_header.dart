import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class TimelineSectionHeader extends StatelessWidget {
  const TimelineSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MBGSizes.md),
          child: Row(
            children: [
              Container(
                width: MBGSizes.xs,
                height: MBGSizes.lg,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MBGColors.primary,
                      MBGColors.primary.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(
                    MBGSizes.borderRadiusSm / 2,
                  ),
                ),
              ),
              const SizedBox(width: MBGSizes.borderRadiusLg),
              Text(
                'Timeline Proses',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MBGColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: MBGSizes.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MBGSizes.md),
          child: Row(
            children: [
              const SizedBox(width: MBGSizes.md),
              Icon(
                Iconsax.info_circle,
                size: MBGSizes.iconSm,
                color: MBGColors.darkGrey,
              ),
              const SizedBox(width: MBGSizes.sm),
              Text(
                'Pantau setiap tahapan proses dapur',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: MBGColors.darkGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
