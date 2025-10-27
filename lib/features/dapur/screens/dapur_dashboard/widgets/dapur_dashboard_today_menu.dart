import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_dashboard_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_today_menu_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurDashboardTodayMenu extends StatelessWidget {
  const DapurDashboardTodayMenu({super.key});

  @override
  Widget build(BuildContext context) {
    DapurDashboardController controller = Get.put(DapurDashboardController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Heading
        MBGSectionHeading(
          showLeadingIcon: true,
          leadingIcon: Iconsax.note,
          title: "Today's Menus",
          showActionButton: true,
          actionButtonTitle: '${controller.todaysMenus.length} menus',
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems / 2),

        // If no menus for today
        if (controller.todaysMenus.isEmpty)
          Container(
            padding: const EdgeInsets.all(MBGSizes.defaultSpace),
            decoration: BoxDecoration(
              color: MBGColors.light,
              border: Border.all(color: MBGColors.grey),
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            ),
            child: Center(
              child: Text(
                'No menus scheduled for today',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MBGColors.textSecondary,
                ),
              ),
            ),
          )
        // Today's Menus List
        else
          ...controller.todaysMenus.map(
            (menu) => DapurDashboardTodayMenuCard(menu: menu),
          ),
      ],
    );
  }
}
