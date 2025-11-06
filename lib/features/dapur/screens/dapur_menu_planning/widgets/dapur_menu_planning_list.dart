import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_planning_delete.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/formatters/formatter.dart';

/// List widget displaying menu planning weeks from API data
class DapurMenuPlanningList extends StatelessWidget {
  const DapurMenuPlanningList({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurMenuPlanningController dapurMenuPlanningController =
        Get.find<DapurMenuPlanningController>();

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
            color: MBGColors.light,
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
            border: Border.all(color: MBGColors.borderPrimary),
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
          separatorBuilder: (_, __) =>
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
                  : MBGColors.light;

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
                    border: Border.all(
                      color: isSelected
                          ? MBGColors.primary
                          : MBGColors.borderPrimary,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Week ${menuPlan.mingguanKe}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? MBGColors.primary
                              : MBGColors.textPrimary,
                        ),
                      ),
                      Text(
                        MBGFormatter.formatDateRange(
                          menuPlan.tanggalMulai,
                          menuPlan.tanggalSelesai,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${menuPlan.count.menuHarian} Menu',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: MBGColors.textSecondary),
                          ),

                          // Edit and Delete Buttons
                          Row(
                            children: [
                              // SizedBox(
                              //   width: 32,
                              //   height: 32,
                              //   child: IconButton(
                              //     padding: EdgeInsets.zero,
                              //     constraints: const BoxConstraints(),
                              //     onPressed: () {},
                              //     icon: const Icon(
                              //       Iconsax.edit_2,
                              //       size: MBGSizes.iconSm,
                              //       color: MBGColors.primary,
                              //     ),
                              //   ),
                              // ),
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
