import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurMenuHarianHeader extends StatelessWidget {
  const DapurMenuHarianHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Week 1 Menu Planning',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: MBGSizes.sm,
                vertical: MBGSizes.xs,
              ),
              decoration: BoxDecoration(
                color: MBGColors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: MBGColors.primary.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
              ),
              child: Text(
                '3 menus',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: MBGColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems / 2),
        Column(
          children: [
            Text(
              'Sekolah Harapan Bangsa',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '01 Nov 2025 - 07 Nov 2025',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
