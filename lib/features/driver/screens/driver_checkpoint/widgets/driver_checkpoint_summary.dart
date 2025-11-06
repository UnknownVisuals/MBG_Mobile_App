import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/styles/shadow_styles.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DriverCheckpointSummary extends StatelessWidget {
  const DriverCheckpointSummary({
    super.key,
    required this.completedCount,
    required this.totalCount,
  });

  final int completedCount, totalCount;

  @override
  Widget build(BuildContext context) {
    final bool hasTotal = totalCount > 0;
    final double progress = hasTotal ? completedCount / totalCount : 0;
    final int progressPercentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: MBGColors.primaryGradient,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        boxShadow: [MBGShadowStyles.primaryCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress Hari Ini',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: MBGColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$completedCount dari $totalCount checkpoint selesai',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: MBGColors.grey),
                  ),
                ],
              ),
              Text(
                '$progressPercentage%',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: MBGColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          ClipRRect(
            borderRadius: BorderRadius.circular(MBGSizes.sm),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: MBGSizes.sm,
              backgroundColor: MBGColors.accent,
              valueColor: const AlwaysStoppedAnimation<Color>(MBGColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
