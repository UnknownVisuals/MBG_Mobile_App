import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/chip_filter.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_qr_scanner.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_delivery_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_delivery/widgets/sekolah_delivery_action_button.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_delivery/widgets/sekolah_delivery_list.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahDeliveryScreen extends StatelessWidget {
  const SekolahDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SekolahDeliveryController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Obx(() {
            final deliveries = controller.filteredDeliveries;
            final isLoading = controller.isLoading.value;
            final hasData = deliveries.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: MBGSizes.spaceBtwSections),
                Text(
                  'Pengiriman Sekolah',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: MBGSizes.xs),
                Text(
                  controller.sekolahName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MBGColors.textSecondary,
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                SekolahDeliveryActionButton(
                  onTap: () {
                    Get.to(
                      () => DriverDashboardQrScanner(
                        onScanned: controller.handleScannedSekolahQrCode,
                        onClose: () => Get.back(),
                      ),
                    );
                  },
                  isProcessing: controller.isSubmitting.value,
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      MBChipFilter(
                        chipFilterString: 'Semua (${controller.totalCount})',
                        chipFilterColor: Colors.blue,
                        chipFilterIcon: Iconsax.grid_3,
                        isSelected: controller.selectedFilter.value == 'all',
                        onTap: () => controller.setFilter('all'),
                      ),
                      const SizedBox(width: MBGSizes.spaceBtwItems),
                      MBChipFilter(
                        chipFilterString:
                            'Pending (${controller.pendingCount})',
                        chipFilterColor: Colors.orange,
                        chipFilterIcon: Iconsax.clock,
                        isSelected:
                            controller.selectedFilter.value == 'pending',
                        onTap: () => controller.setFilter('pending'),
                      ),
                      const SizedBox(width: MBGSizes.spaceBtwItems),
                      MBChipFilter(
                        chipFilterString:
                            'Dalam Perjalanan (${controller.inTransitCount})',
                        chipFilterColor: Colors.purple,
                        chipFilterIcon: Iconsax.truck_fast,
                        isSelected:
                            controller.selectedFilter.value == 'in_transit',
                        onTap: () => controller.setFilter('in_transit'),
                      ),
                      const SizedBox(width: MBGSizes.spaceBtwItems),
                      MBChipFilter(
                        chipFilterString:
                            'Selesai (${controller.completedCount})',
                        chipFilterColor: Colors.green,
                        chipFilterIcon: Iconsax.tick_circle,
                        isSelected:
                            controller.selectedFilter.value == 'completed',
                        onTap: () => controller.setFilter('completed'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: MBGColors.primary,
                          ),
                        )
                      : hasData
                      ? SekolahDeliveryList(
                          deliveries: deliveries,
                          onRefresh: controller.refreshDeliveries,
                        )
                      : Center(
                          child: Text(
                            'Belum ada pengiriman pada sekolah ini.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
