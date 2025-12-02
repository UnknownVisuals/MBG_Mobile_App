import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_planning_delete.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/formatters/formatter.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurMenuPlanningList extends StatelessWidget {
  const DapurMenuPlanningList({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurMenuPlanningController dapurMenuPlanningController =
        Get.find<DapurMenuPlanningController>();

    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    return Obx(() {
      if (dapurMenuPlanningController.isLoading.value) {
        return const SizedBox(
          height: 110,
          child: Center(
            child: CircularProgressIndicator(color: MBGColors.primary),
          ),
        );
      }

      if (dapurMenuPlanningController.menuPlanningList.isEmpty) {
        return Container(
          height: 110,
          alignment: Alignment.center,
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
          child: Text(
            'Belum ada menu planning',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: MBGColors.textSecondary),
          ),
        );
      }

      return SizedBox(
        height: 110,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: dapurMenuPlanningController.menuPlanningList.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: MBGSizes.spaceBtwItems),
          itemBuilder: (context, index) {
            final menuPlan =
                dapurMenuPlanningController.menuPlanningList[index];

            return Obx(() {
              final isSelected =
                  dapurMenuPlanningController.selectedMenuPlanningId.value ==
                  menuPlan.id;

              final cardColor = isSelected
                  ? MBGColors.primary.withValues(alpha: 0.1)
                  : (isDarkMode ? MBGColors.dark : MBGColors.light);

              final borderColor = isSelected
                  ? MBGColors.primary
                  : (isDarkMode
                        ? MBGColors.lightGrey.withValues(alpha: 0.4)
                        : MBGColors.grey);

              return GestureDetector(
                onTap: () =>
                    dapurMenuPlanningController.selectMenuPlanning(menuPlan.id),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Week ${menuPlan.mingguanKe}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? MBGColors.primary : null,
                        ),
                      ),
                      Text(
                        MBGFormatter.formatDateRange(
                          menuPlan.tanggalMulai!,
                          menuPlan.tanggalSelesai!,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? MBGColors.primary
                              : MBGColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${menuPlan.count?.menuHarian ?? 0} Menu',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: MBGColors.textSecondary),
                          ),
                          // Delete button
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.dialog(
                                  DapurMenuPlanningDelete(
                                    menuPlanning: menuPlan,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Iconsax.trash,
                                size: MBGSizes.iconSm,
                                color: MBGColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }
}
