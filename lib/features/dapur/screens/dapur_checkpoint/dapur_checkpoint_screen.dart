import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_harian_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_list.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_summary.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurCheckpointScreen extends StatelessWidget {
  const DapurCheckpointScreen({super.key, this.menuHarianId});

  final String? menuHarianId;

  @override
  Widget build(BuildContext context) {
    final DapurCheckpointController dapurCheckpointController = Get.put(
      DapurCheckpointController(),
    );
    final DapurMenuHarianController menuHarianController =
        Get.find<DapurMenuHarianController>();

    dapurCheckpointController.initializeWithMenuId(menuHarianId);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final dropdownBgColor = isDark ? Colors.grey[850] : Colors.white;
    final dropdownBorderColor =
        isDark ? Colors.grey[700]! : Colors.grey[300]!; // border
    final dropdownHintColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final dateTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

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
                  Icon(Icons.info_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  Text(
                    'Tidak ada menu harian tersedia',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: dropdownHintColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Show loading
        if (dapurCheckpointController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show checkpoint list
        return RefreshIndicator(
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
                    color: dropdownBgColor,
                    borderRadius:
                        BorderRadius.circular(MBGSizes.cardRadiusMd),
                    border: Border.all(color: dropdownBorderColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value:
                          dapurCheckpointController.currentMenuHarianId.value,
                      hint: Text(
                        'Pilih Menu Harian',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: dropdownHintColor),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: theme.colorScheme.primary,
                      ),
                      items: menuHarianController.menuHarianList.map((menuHarian) {
                        return DropdownMenuItem<String>(
                          value: menuHarian.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                menuHarian.namaMenu,
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                DateFormat('dd MMM yyyy').format(menuHarian.tanggal),
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: dateTextColor),
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
