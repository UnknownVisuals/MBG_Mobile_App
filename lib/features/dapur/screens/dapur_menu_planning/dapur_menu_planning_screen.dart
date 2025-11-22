import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_info_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_harian_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_add.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_list.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_header.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_planning_header.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_planning_list.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurMenuPlanningScreen extends StatelessWidget {
  const DapurMenuPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller initialization
    Get.put(DapurInfoController());
    final DapurMenuPlanningController dapurMenuPlanningController =
        Get.put(DapurMenuPlanningController());
    Get.put(DapurMenuHarianController());

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(const DapurMenuHarianAdd()),
        backgroundColor: colorScheme.primary,
        icon: Icon(Iconsax.add, color: colorScheme.onPrimary),
        label: Text(
          'Menu Harian',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await dapurMenuPlanningController.refreshMenuPlanning();
        },
        color: colorScheme.primary,

        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: MBGSpacingStyles.homeScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DapurMenuPlanningHeader(),
                  const SizedBox(height: MBGSizes.spaceBtwItems),

                  const DapurMenuPlanningList(),
                  const SizedBox(height: MBGSizes.spaceBtwItems),

                  const DapurMenuHarianHeader(),
                  const SizedBox(height: MBGSizes.spaceBtwItems),

                  const DapurMenuHarianList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
