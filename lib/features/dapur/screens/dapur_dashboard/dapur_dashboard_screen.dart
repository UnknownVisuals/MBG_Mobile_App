import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_dashboard_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_cooking_progress.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_header.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_pending_delivery.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_today_menu.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/empty_dapur_dashboard.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Main dapur dashboard screen
class DapurDashboardScreen extends StatelessWidget {
  const DapurDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DapurDashboardController());
    final dapurController = Get.find<DapurController>();

    return Scaffold(
      body: Obx(() {
        final selectedDapur = dapurController.selectedDapur.value;
        final isKitchenLoading = dapurController.isDapurLoading.value;

        if (isKitchenLoading && selectedDapur == null) {
          return const Center(
            child: CircularProgressIndicator(color: MBGColors.primary),
          );
        }

        if (selectedDapur == null) {
          return EmptyDapurDashboard(
            controller: controller,
            errorMessage: dapurController.dapurError.value,
          );
        }

        if (controller.isLoading.value && controller.todaysMenus.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: MBGColors.primary),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          color: MBGColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: MBGSpacingStyles.homeScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                DapurDashboardHeader(),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Stats Cards Row
                Row(
                  children: [
                    Expanded(
                      child: DapurDashboardCard(
                        icon: Iconsax.calendar_1,
                        label: 'Active Plans',
                        value: controller.activeMenuPlansCount.value.toString(),
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: MBGSizes.spaceBtwItems),
                    Expanded(
                      child: DapurDashboardCard(
                        icon: Iconsax.task_square,
                        label: 'Checkpoints',
                        value: controller.completedCheckpointsToday.value
                            .toString(),
                        color: MBGColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Cooking Progress
                DapurDashboardCookingProgress(),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Today's Menus
                DapurDashboardTodayMenu(),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Pending Deliveries
                DapurDashboardPendingDelivery(),
                const SizedBox(height: MBGSizes.spaceBtwSections),
              ],
            ),
          ),
        );
      }),
    );
  }
}
