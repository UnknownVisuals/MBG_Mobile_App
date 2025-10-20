import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class ProgressSummaryCard extends StatelessWidget {
  final int completedCount;
  final int totalCount;

  const ProgressSummaryCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage = (completedCount / totalCount * 100).round();

    return Container(
      margin: const EdgeInsets.all(MBGSizes.md),
      padding: const EdgeInsets.all(MBGSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MBGColors.primary, MBGColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.lg),
        boxShadow: [
          BoxShadow(
            color: MBGColors.primary.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, MBGSizes.sm),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const SizedBox(height: MBGSizes.xs),
                  Text(
                    'Total $completedCount dari $totalCount selesai',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MBGColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(MBGSizes.md),
                decoration: BoxDecoration(
                  color: MBGColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    MBGSizes.borderRadiusLg + 3,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$progressPercentage%',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: MBGColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Complete',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MBGColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd + 2),
            child: LinearProgressIndicator(
              value: completedCount / totalCount,
              minHeight: MBGSizes.sm,
              backgroundColor: MBGColors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(MBGColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
