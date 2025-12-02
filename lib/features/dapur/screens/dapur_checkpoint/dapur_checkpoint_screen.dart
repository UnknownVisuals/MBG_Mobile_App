import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_harian_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_list.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_summary.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurCheckpointScreen extends StatelessWidget {
  const DapurCheckpointScreen({super.key, this.menuHarianId});

  final String? menuHarianId;

  @override
  Widget build(BuildContext context) {
    final DapurCheckpointController dapurCheckpointController = Get.put(
      DapurCheckpointController(),
    );
    final DapurMenuHarianController menuHarianController = Get.put(
      DapurMenuHarianController(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (menuHarianId != null &&
          dapurCheckpointController.currentMenuHarianId.value != menuHarianId) {
        dapurCheckpointController.initializeWithMenuId(menuHarianId);
      }
    });

    final theme = Theme.of(context);
    final isDark = MBGHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Obx(() {
        // Show placeholder if no menu harian available
        if (menuHarianController.menuHarianList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(MBGSizes.defaultSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 64,
                    color: MBGColors.darkGrey,
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  Text(
                    'Tidak ada menu harian tersedia',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: MBGColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Show loading
        if (dapurCheckpointController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: MBGColors.primary),
          );
        }

        // Show checkpoint list
        return RefreshIndicator(
          color: MBGColors.primary,
          onRefresh: () =>
              dapurCheckpointController.fetchCheckpointsByMenuHarian(
                dapurCheckpointController.currentMenuHarianId.value!,
              ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: MBGSpacingStyles.homeScreenPadding,
            child: Column(
              children: [
                // Menu Harian Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MBGSizes.md,
                    vertical: MBGSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? MBGColors.dark : MBGColors.white,
                    borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
                    border: Border.all(color: MBGColors.borderPrimary),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value:
                          dapurCheckpointController.currentMenuHarianId.value,
                      hint: Text(
                        'Pilih Menu Harian',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: MBGColors.textSecondary,
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: MBGColors.primary,
                      ),
                      items: menuHarianController.menuHarianList.map((
                        menuHarian,
                      ) {
                        return DropdownMenuItem<String>(
                          value: menuHarian.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                menuHarian.namaMenu!,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                  'id_ID',
                                ).format(menuHarian.tanggal!.toLocal()),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: MBGColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          dapurCheckpointController.changeMenuHarian(newValue);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                DapurCheckpointSummary(
                  completedCount: dapurCheckpointController.completedCount,
                  totalCount: dapurCheckpointController.totalCount,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                const DapurCheckpointList(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
