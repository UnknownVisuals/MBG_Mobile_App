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
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DapurMenuPlanningScreen extends StatelessWidget {
  const DapurMenuPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller initialization
    Get.put(DapurInfoController());
    final DapurMenuPlanningController dapurMenuPlanningController = Get.put(
      DapurMenuPlanningController(),
    );
    Get.put(DapurMenuHarianController());

    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final selectedId =
              dapurMenuPlanningController.selectedMenuPlanningId.value;
          if (selectedId == null) {
            MBGLoaders.warningSnackBar(
              title: 'Pilih Menu Planning',
              message: 'Silakan pilih menu planning terlebih dahulu.',
            );
            return;
          }

          final menuPlanning = dapurMenuPlanningController.menuPlanningList
              .firstWhereOrNull((element) => element.id == selectedId);

          if (menuPlanning == null) {
            MBGLoaders.warningSnackBar(
              title: 'Error',
              message: 'Data menu planning tidak ditemukan.',
            );
            return;
          }

          if (menuPlanning.tanggalMulai == null ||
              menuPlanning.tanggalSelesai == null) {
            MBGLoaders.warningSnackBar(
              title: 'Error',
              message: 'Tanggal menu planning tidak valid.',
            );
            return;
          }

          Get.to(
            () => DapurMenuHarianAdd(
              menuPlanningId: selectedId,
              startDate: menuPlanning.tanggalMulai!,
              endDate: menuPlanning.tanggalSelesai!,
            ),
          );
        },
        backgroundColor: MBGColors.primary,
        icon: const Icon(Iconsax.add, color: MBGColors.white),
        label: Text(
          'Menu Harian',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: MBGColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await dapurMenuPlanningController.refreshMenuPlanning();
        },
        color: MBGColors.primary,

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
    );
  }
}
