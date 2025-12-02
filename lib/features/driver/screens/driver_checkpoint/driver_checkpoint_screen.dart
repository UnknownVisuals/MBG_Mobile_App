import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_checkpoint/widgets/driver_checkpoint_list.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_checkpoint/widgets/driver_checkpoint_summary.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DriverCheckpointScreen extends StatelessWidget {
  const DriverCheckpointScreen({super.key, this.menuHarianId});

  final String? menuHarianId;

  @override
  Widget build(BuildContext context) {
    final driverController = Get.put(DriverCheckpointController());
    final dapurCheckpointController = Get.put(DapurCheckpointController());

    if (menuHarianId != null &&
        dapurCheckpointController.currentMenuHarianId.value != menuHarianId) {
      dapurCheckpointController.initializeWithMenuId(menuHarianId);
      driverController.selectMenuHarian(menuHarianId);
    }

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final isMenuPlanningLoading =
              driverController.isMenuPlanningLoading.value;
          final isMenuHarianLoading =
              driverController.isMenuHarianLoading.value;
          final selectedMenuPlanningId =
              driverController.selectedMenuPlanningId.value;
          final selectedMenuHarianId =
              driverController.selectedMenuHarianId.value;

          if (isMenuPlanningLoading &&
              driverController.menuPlanningList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (selectedMenuHarianId != null) {
                await dapurCheckpointController.fetchCheckpointsByMenuHarian(
                  selectedMenuHarianId,
                );
                return;
              }

              if (selectedMenuPlanningId != null) {
                await driverController.fetchMenuHarian(
                  planningId: selectedMenuPlanningId,
                );
                return;
              }

              await driverController.fetchAllMenuPlanning();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: MBGSpacingStyles.homeScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownCard(
                    context: context,
                    label: 'Menu Planning',
                    hint: 'Pilih Menu Planning',
                    value: driverController.selectedMenuPlanningId.value,
                    items: driverController.menuPlanningList
                        .map(
                          (planning) => DropdownMenuItem<String>(
                            value: planning.id,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Minggu ke-${planning.mingguanKe}',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                ),
                                Text(
                                  '${DateFormat('dd MMM yyyy', 'id_ID').format(planning.tanggalMulai!.toLocal())} - '
                                  '${DateFormat('dd MMM yyyy', 'id_ID').format(planning.tanggalSelesai!.toLocal())}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: isMenuPlanningLoading
                        ? null
                        : (value) {
                            dapurCheckpointController
                                    .currentMenuHarianId
                                    .value =
                                null;
                            dapurCheckpointController.checkpointList.clear();
                            driverController.selectMenuPlanning(value);
                          },
                    isLoading: isMenuPlanningLoading,
                  ),

                  if (!isMenuPlanningLoading &&
                      driverController.menuPlanningList.isEmpty)
                    _buildEmptyMessage(
                      context,
                      'Menu planning belum tersedia untuk saat ini.',
                    ),

                  const SizedBox(height: MBGSizes.spaceBtwSections),

                  _buildDropdownCard(
                    context: context,
                    label: 'Menu Harian',
                    hint: driverController.selectedMenuPlanningId.value == null
                        ? 'Pilih menu planning terlebih dahulu'
                        : 'Pilih Menu Harian',
                    value: driverController.selectedMenuHarianId.value,
                    items: driverController.menuHarianList.map((menuHarian) {
                      return DropdownMenuItem<String>(
                        value: menuHarian.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              menuHarian.namaMenu!,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat(
                                'dd MMM yyyy',
                                'id_ID',
                              ).format(menuHarian.tanggal!.toLocal()),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged:
                        (driverController.selectedMenuPlanningId.value ==
                                null ||
                            isMenuHarianLoading)
                        ? null
                        : (value) {
                            driverController.selectMenuHarian(value);
                            if (value != null) {
                              dapurCheckpointController.changeMenuHarian(value);
                            }
                          },
                    isLoading: isMenuHarianLoading,
                  ),

                  if (driverController.selectedMenuPlanningId.value != null &&
                      !isMenuHarianLoading &&
                      driverController.menuHarianList.isEmpty)
                    _buildEmptyMessage(
                      context,
                      'Menu harian belum tersedia untuk menu planning ini.',
                    ),

                  const SizedBox(height: MBGSizes.spaceBtwSections),

                  if (selectedMenuHarianId == null)
                    driverController.menuHarianList.isNotEmpty
                        ? _buildEmptyMessage(
                            context,
                            'Silakan pilih menu harian untuk melihat checkpoint.',
                          )
                        : const SizedBox.shrink()
                  else if (dapurCheckpointController.isLoading.value)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    DriverCheckpointSummary(
                      completedCount: dapurCheckpointController.completedCount,
                      totalCount: dapurCheckpointController.totalCount,
                    ),
                    const SizedBox(height: MBGSizes.spaceBtwSections),
                    const DriverCheckpointList(),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDropdownCard({
    required BuildContext context,
    required String label,
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?>? onChanged,
    required bool isLoading,
  }) {
    final hasValue = value != null && items.any((item) => item.value == value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: MBGSizes.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: MBGSizes.md,
            vertical: MBGSizes.sm,
          ),
          decoration: BoxDecoration(
            color: MBGHelperFunctions.isDarkMode(context)
                ? MBGColors.dark
                : MBGColors.white,
            borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            border: Border.all(
              color: MBGHelperFunctions.isDarkMode(context)
                  ? MBGColors.lightGrey.withValues(alpha: 0.4)
                  : MBGColors.borderPrimary,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: hasValue ? value : null,
              hint: Text(
                hint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.primary,
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: MBGSizes.xs),
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }

  Widget _buildEmptyMessage(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: MBGSizes.sm),
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: MBGHelperFunctions.isDarkMode(context)
            ? MBGColors.dark
            : MBGColors.lightContainer,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(
          color: MBGHelperFunctions.isDarkMode(context)
              ? MBGColors.lightGrey.withValues(alpha: 0.4)
              : MBGColors.borderPrimary,
        ),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
