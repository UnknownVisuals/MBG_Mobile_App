import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_harian_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

/// Dynamic list of daily menus fetched from API based on selected menu planning
class DapurMenuHarianList extends StatelessWidget {
  const DapurMenuHarianList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DapurMenuHarianController>();
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: MBGColors.primary),
        );
      }

      if (controller.menuHarianList.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(MBGSizes.defaultSpace),
          decoration: BoxDecoration(
            color: isDarkMode ? MBGColors.dark : MBGColors.light,
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
            border: Border.all(
              color: isDarkMode
                  ? MBGColors.lightGrey.withValues(alpha: 0.4)
                  : MBGColors.grey,
            ),
          ),
          child: Center(
            child: Text(
              'Belum ada menu harian untuk minggu ini',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: MBGColors.textSecondary),
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.menuHarianList.map((menuHarian) {
          return Column(
            children: [
              DapurMenuHarianCard(menuHarian: menuHarian),
              const SizedBox(height: MBGSizes.spaceBtwItems),
            ],
          );
        }).toList(),
      );
    });
  }
}
