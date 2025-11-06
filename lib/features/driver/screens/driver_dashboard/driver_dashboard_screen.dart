import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_controller.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_delivery_card.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_header.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_qr_scanner.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_quick_action_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DriverDashboardScreen extends GetView<DriverController> {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final errorMessage = controller.errorMessage.value;
      final deliveries = controller.deliveries;

      // final pendingDeliveries = deliveries.where((delivery) {
      //   return _isPending(delivery);
      // }).length;

      final ongoingDeliveries = deliveries.where(_isOngoing).toList();
      // final completedDeliveries = deliveries.where(_isCompleted).length;

      return Scaffold(
        body: RefreshIndicator(
          onRefresh: controller.fetchDeliveries,
          color: MBGColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: MBGSpacingStyles.homeScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DriverDashboardHeader(),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // DriverDashboardStatsRow(
                //   pending: pendingDeliveries + ongoingDeliveries.length,
                //   complete: completedDeliveries,
                // ),
                // const SizedBox(height: MBGSizes.spaceBtwItems),
                GestureDetector(
                  onTap: () => Get.to(
                    () => DriverDashboardQrScanner(
                      onScanned: controller.handleScannedQrCode,
                    ),
                  ),
                  child: const DriverDashboardQuickActionCard(),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                MBGSectionHeading(
                  title: 'Sedang Diantar',
                  showActionButton: true,
                  actionButtonTitle: "${ongoingDeliveries.length} diantar",
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                if (isLoading && deliveries.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: MBGSizes.lg),
                      child: CircularProgressIndicator(
                        color: MBGColors.primary,
                      ),
                    ),
                  )
                else if (errorMessage.isNotEmpty && deliveries.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: MBGSizes.lg,
                      horizontal: MBGSizes.md,
                    ),
                    decoration: BoxDecoration(
                      color: MBGColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(
                        MBGSizes.cardRadiusMd,
                      ),
                    ),
                    child: Text(
                      errorMessage,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: MBGColors.error),
                    ),
                  )
                else if (ongoingDeliveries.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: MBGSizes.lg,
                      horizontal: MBGSizes.md,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        MBGSizes.cardRadiusMd,
                      ),
                    ),
                    child: Text(
                      'Belum ada pengantaran yang sedang berlangsung.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  )
                else
                  ...ongoingDeliveries.map(
                    (delivery) =>
                        DriverDashboardDeliveryCard(delivery: delivery),
                  ),

                if (isLoading && deliveries.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: MBGSizes.md),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: MBGColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// bool _isPending(DriverDeliveryModel delivery) {
//   final status = delivery.status.replaceAll('_', ' ').toUpperCase();
//   return status == 'PENDING';
// }

bool _isOngoing(DriverDeliveryModel delivery) {
  final status = delivery.status.replaceAll('_', ' ').toUpperCase();
  return status == 'SEDANG DIANTAR' || status == 'IN TRANSIT';
}

// bool _isCompleted(DriverDeliveryModel delivery) {
//   final status = delivery.status.replaceAll('_', ' ').toUpperCase();
//   return status == 'DELIVERED' || status == 'SELESAI';
// }
