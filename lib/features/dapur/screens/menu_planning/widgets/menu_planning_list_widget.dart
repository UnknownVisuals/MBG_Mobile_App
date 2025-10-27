import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/menu_planning_controller.dart';

/// List widget displaying menu planning weeks
class MenuPlanningListWidget extends StatelessWidget {
  final MenuPlanningController controller;

  const MenuPlanningListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(MBGSizes.md),
        itemCount: controller.menuPlannings.length,
        itemBuilder: (context, index) {
          final planning = controller.menuPlannings[index];
          final isSelected =
              controller.selectedPlanning.value?.id == planning.id;

          return Obx(
            () => Card(
              elevation: isSelected ? 4 : 1,
              color: isSelected ? MBGColors.primary.withOpacity(0.1) : null,
              margin: const EdgeInsets.only(bottom: MBGSizes.sm),
              child: ListTile(
                onTap: () => controller.selectPlanning(planning),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MBGColors.primary
                        : MBGColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'W${planning.mingguanKe}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : MBGColors.primary,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Week ${planning.mingguanKe}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${DateFormat('dd MMM').format(planning.tanggalMulai)} - ${DateFormat('dd MMM yyyy').format(planning.tanggalSelesai)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Icon(
                  isSelected ? Iconsax.tick_circle5 : Iconsax.arrow_right_3,
                  color: isSelected ? MBGColors.primary : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
