import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_pending_delivery_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurDashboardPendingDelivery extends StatelessWidget {
  const DapurDashboardPendingDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    final pending = 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MBGSectionHeading(
          showLeadingIcon: true,
          leadingIcon: Iconsax.truck,
          title: 'Pending Deliveries',
          showActionButton: true,
          actionButtonTitle: '$pending pending',
        ),

        const SizedBox(height: MBGSizes.spaceBtwItems / 2),

        if (pending == 0)
          Container(
            padding: const EdgeInsets.all(MBGSizes.defaultSpace),
            decoration: BoxDecoration(
              color: isDarkMode ? MBGColors.dark : MBGColors.light,
              border: Border.all(
                color: isDarkMode
                    ? MBGColors.lightGrey.withValues(alpha: 0.4)
                    : MBGColors.darkGrey.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Iconsax.truck,
                    size: MBGSizes.iconLg,
                    color: MBGColors.textSecondary,
                  ),

                  const SizedBox(height: MBGSizes.spaceBtwItems),

                  Text(
                    'All deliveries completed',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MBGColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          DapurDashboardDeliveryCard(),
      ],
    );
  }
}
