import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class TimelineHeader extends StatelessWidget {
  const TimelineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MBGSizes.xs,
          height: MBGSizes.xl,
          decoration: BoxDecoration(
            color: MBGColors.primary,
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm / 2),
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timeline Proses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: MBGColors.textPrimary,
              ),
            ),
            Text(
              'Pantau setiap tahapan proses',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: MBGColors.darkGrey),
            ),
          ],
        ),
      ],
    );
  }
}
