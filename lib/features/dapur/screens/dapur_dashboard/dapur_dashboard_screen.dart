import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/dapur_controller.dart';
import '../../controllers/dapur_dashboard_controller.dart';
import 'widgets/dapur_dashboard_delivery_card_widget.dart';
import 'widgets/dapur_dashboard_menu_card_widget.dart';
import 'widgets/dapur_dashboard_stat_card_widget.dart';
import 'widgets/dapur_dashboard_stock_alert_card_widget.dart';
import 'widgets/no_assigned_kitchen_widget.dart';

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
          return const Center(child: CircularProgressIndicator());
        }

        if (selectedDapur == null) {
          return NoAssignedKitchenWidget(
            controller: controller,
            errorMessage: dapurController.dapurError.value,
          );
        }

        if (controller.isLoading.value && controller.todaysMenus.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: MBGSpacingStyles.homeScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, dapurController),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Stats Cards Row
                _buildStatsCards(controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Cooking Progress
                _buildCookingProgress(context, controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Today's Menus
                _buildTodaysMenus(context, controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Pending Deliveries
                _buildPendingDeliveries(context, controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Low Stock Alerts
                _buildLowStockAlerts(context, controller),
                const SizedBox(height: MBGSizes.spaceBtwItems),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, DapurController dapurController) {
    final selectedDapur = dapurController.selectedDapur.value;
    final assignedDapur = dapurController.assignedDapur;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kitchen Dashboard',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        if (selectedDapur != null) ...[
          const SizedBox(height: MBGSizes.spaceBtwItems),
          if (assignedDapur.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDapur.id,
                  isExpanded: true,
                  icon: const Icon(Iconsax.arrow_down_1),
                  onChanged: (value) {
                    if (value != null && value != selectedDapur.id) {
                      dapurController.selectDapur(value);
                    }
                  },
                  items: assignedDapur
                      .map(
                        (dapur) => DropdownMenuItem<String>(
                          value: dapur.id,
                          child: Text(
                            dapur.nama,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Iconsax.building,
                  size: 18,
                  color: MBGColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDapur.nama,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (selectedDapur.alamat.isNotEmpty)
                        Text(
                          selectedDapur.alamat,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ],
    );
  }

  Widget _buildStatsCards(DapurDashboardController controller) {
    return Row(
      children: [
        Expanded(
          child: DapurDashboardStatCardWidget(
            icon: Iconsax.calendar_1,
            label: 'Active Plans',
            value: controller.activeMenuPlansCount.value.toString(),
            color: MBGColors.primary,
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Expanded(
          child: DapurDashboardStatCardWidget(
            icon: Iconsax.task_square,
            label: 'Checkpoints',
            value: controller.completedCheckpointsToday.value.toString(),
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildCookingProgress(
    BuildContext context,
    DapurDashboardController controller,
  ) {
    final progress = controller.getCookingProgress();

    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.timer_1, color: MBGColors.primary),
              const SizedBox(width: 8),
              Text(
                'Today\'s Cooking Progress',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 80
                          ? Colors.green
                          : progress >= 50
                          ? Colors.orange
                          : MBGColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${progress.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.todaysMenus.length} menus today • ${controller.completedCheckpointsToday.value} checkpoints completed',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysMenus(
    BuildContext context,
    DapurDashboardController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Iconsax.note, color: MBGColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Menus',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '${controller.todaysMenus.length} menus',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),
        if (controller.todaysMenus.isEmpty)
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            ),
            child: Center(
              child: Text(
                'No menus scheduled for today',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...controller.todaysMenus.map(
            (menu) => DapurDashboardMenuCardWidget(menu: menu),
          ),
      ],
    );
  }

  Widget _buildPendingDeliveries(
    BuildContext context,
    DapurDashboardController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Iconsax.truck, color: MBGColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Pending Deliveries',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '${controller.pendingDeliveries.length} pending',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),
        if (controller.pendingDeliveries.isEmpty)
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            ),
            child: Center(
              child: Text(
                'All deliveries completed',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...controller.pendingDeliveries.map(
            (delivery) => DapurDashboardDeliveryCardWidget(delivery: delivery),
          ),
      ],
    );
  }

  Widget _buildLowStockAlerts(
    BuildContext context,
    DapurDashboardController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Iconsax.box, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Low Stock Alerts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '${controller.lowStockItems.length} items',
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),
        if (controller.lowStockItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            ),
            child: Center(
              child: Text(
                'All stock levels are healthy',
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
          )
        else
          ...controller.lowStockItems.map(
            (item) => DapurDashboardStockAlertCardWidget(item: item),
          ),
      ],
    );
  }
}
