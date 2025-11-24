import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_planning_delete.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/formatters/formatter.dart';

class DapurMenuPlanningList extends StatelessWidget {
  const DapurMenuPlanningList({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurMenuPlanningController dapurMenuPlanningController =
        Get.find<DapurMenuPlanningController>();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      if (dapurMenuPlanningController.isLoading.value) {
        return SizedBox(
          height: 110,
          child: Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
        );
      }

      if (dapurMenuPlanningController.menuPlanningList.isEmpty) {
        return Container(
          height: 110,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(MBGSizes.defaultSpace),
          decoration: BoxDecoration(
            color: colorScheme.surface, // adaptive
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
            border: Border.all(color: colorScheme.outline), // adaptive
          ),
          child: Text(
            'Belum ada menu planning',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        );
      }

      return SizedBox(
        height: 110,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: dapurMenuPlanningController.menuPlanningList.length,
          separatorBuilder: (_, __) => const SizedBox(width: MBGSizes.spaceBtwItems),
          itemBuilder: (context, index) {
            final menuPlan = dapurMenuPlanningController.menuPlanningList[index];

            return Obx(() {
              final isSelected =
                  dapurMenuPlanningController.selectedMenuPlanningId.value == menuPlan.id;

              final cardColor = isSelected
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.surface;

              return GestureDetector(
                onTap: () => dapurMenuPlanningController.selectMenuPlanning(menuPlan.id),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                    border: Border.all(
                      color: isSelected ? colorScheme.primary : colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Week ${menuPlan.mingguanKe}',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface, // adaptive
                        ),
                      ),
                      Text(
                        MBGFormatter.formatDateRange(
                          menuPlan.tanggalMulai,
                          menuPlan.tanggalSelesai,
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant, // adaptive
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${menuPlan.count.menuHarian} Menu',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
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
                                  DapurMenuPlanningDelete(menuPlanning: menuPlan),
                                );
                              },
                              icon: Icon(
                                Iconsax.trash,
                                size: MBGSizes.iconSm,
                                color: colorScheme.error, // adaptive
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
