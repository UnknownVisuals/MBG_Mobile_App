import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_today_menu_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurDashboardTodayMenu extends StatelessWidget {
  const DapurDashboardTodayMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    final totalMenus = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MBGSectionHeading(
          showLeadingIcon: true,
          leadingIcon: Iconsax.note,
          title: "Today's Menus",
          showActionButton: true,
          actionButtonTitle: '$totalMenus menus',
        ),

        const SizedBox(height: MBGSizes.spaceBtwItems / 2),

        if (totalMenus == 0)
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
                    Iconsax.note,
                    size: MBGSizes.iconLg,
                    color: MBGColors.textSecondary,
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  Text(
                    'No menus scheduled for today',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MBGColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          DapurDashboardTodayMenuCard(),
      ],
    );
  }
}
