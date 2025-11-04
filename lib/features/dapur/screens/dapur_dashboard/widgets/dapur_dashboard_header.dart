import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_header_selector.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurDashboardHeader extends StatelessWidget {
  const DapurDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and Time Info
        Row(
          children: [
            // Date Info
            Icon(
              Iconsax.calendar,
              size: MBGSizes.iconSm,
              color: MBGColors.primary,
            ),
            const SizedBox(width: MBGSizes.spaceBtwItems / 2),
            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const Spacer(),

            // Time Info
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: MBGSizes.sm,
                vertical: MBGSizes.xs,
              ),
              decoration: BoxDecoration(
                color: MBGColors.primary.withValues(alpha: 0.2),
                border: Border.all(
                  color: MBGColors.primary.withValues(alpha: 0.8),
                ),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Text(
                DateFormat('HH:mm:ss').format(DateTime.now()),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: MBGColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: MBGSizes.spaceBtwItems),

        const DapurDashboardHeaderSelector(),
      ],
    );
  }
}
