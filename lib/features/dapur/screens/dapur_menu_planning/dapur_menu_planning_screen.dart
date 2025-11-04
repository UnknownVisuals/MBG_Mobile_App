import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_add.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_list.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_header.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_planning_header.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_planning_list.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurMenuPlanningScreen extends StatelessWidget {
  const DapurMenuPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurMenuPlanningController dapurMenuPlanningController = Get.put(
      DapurMenuPlanningController(),
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        color: MBGColors.primary,
        child: SingleChildScrollView(
          child: Padding(
            padding: MBGSpacingStyles.homeScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const DapurMenuPlanningHeader(),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Menu Planning List
                const DapurMenuPlanningList(),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Daily menu header
                const DapurMenuHarianHeader(),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                // Daily menu showcase
                const DapurMenuHarianList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(const DapurMenuHarianAdd()),
        backgroundColor: MBGColors.primary,
        icon: Icon(Iconsax.add, color: MBGColors.white),
        label: Text(
          'Menu Harian',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: MBGColors.white),
        ),
      ),
    );
  }
}
