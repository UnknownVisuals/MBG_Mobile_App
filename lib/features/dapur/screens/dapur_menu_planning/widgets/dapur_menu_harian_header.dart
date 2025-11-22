import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_harian_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/formatters/formatter.dart';

class DapurMenuHarianHeader extends StatelessWidget {
  const DapurMenuHarianHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurMenuPlanningController dapurMenuPlanningController =
        Get.find<DapurMenuPlanningController>();
    final DapurMenuHarianController dapurMenuHarianController =
        Get.find<DapurMenuHarianController>();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final selectedPlanningId =
          dapurMenuPlanningController.selectedMenuPlanningId.value;

      final selectedPlanning = dapurMenuPlanningController.menuPlanningList
          .firstWhereOrNull((planning) => planning.id == selectedPlanningId);

      if (selectedPlanning == null) return const SizedBox.shrink();

      final menuCount = dapurMenuHarianController.menuHarianList.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row title + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Week ${selectedPlanning.mingguanKe} Menu Planning',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Badge menu count (adaptive!)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: MBGSizes.sm,
                  vertical: MBGSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
                ),
                child: Text(
                  '$menuCount menu${menuCount != 1 ? 's' : ''}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems / 2),

          // School name + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedPlanning.sekolah.nama,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                MBGFormatter.formatDateRange(
                  selectedPlanning.tanggalMulai,
                  selectedPlanning.tanggalSelesai,
                ),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
