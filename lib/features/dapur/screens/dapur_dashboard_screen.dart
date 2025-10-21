import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

class DapurDashboardScreen extends StatelessWidget {
  const DapurDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DapurDashboardController());

    return Scaffold(
      body: Obx(() {
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
                _buildHeader(context),
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

  Widget _buildHeader(BuildContext context) {
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
      ],
    );
  }

  Widget _buildStatsCards(DapurDashboardController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Iconsax.calendar_1,
            label: 'Active Plans',
            value: controller.activeMenuPlansCount.value.toString(),
            color: MBGColors.primary,
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Expanded(
          child: _buildStatCard(
            icon: Iconsax.task_square,
            label: 'Checkpoints',
            value: controller.completedCheckpointsToday.value.toString(),
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
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
              Icon(Iconsax.timer_1, color: MBGColors.primary),
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
    if (controller.todaysMenus.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(MBGSizes.md),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Iconsax.note, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No menus scheduled for today',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Menus',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/dapur/menu-planning'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),
        ...controller.todaysMenus.map((menu) => _buildMenuCard(menu)),
      ],
    );
  }

  Widget _buildMenuCard(menu) {
    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MBGColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.note, color: MBGColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.namaMenu,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${menu.jamMulaiMasak} - ${menu.jamSelesaiMasak}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Rp ${NumberFormat('#,###').format(menu.biayaPerTray)}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
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
            Text(
              'Pending Deliveries',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.pendingDeliveriesCount.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
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
              child: Column(
                children: [
                  Icon(Iconsax.truck, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'No pending deliveries',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
          ...controller.pendingDeliveries
              .take(3)
              .map((delivery) => _buildDeliveryCard(delivery)),
      ],
    );
  }

  Widget _buildDeliveryCard(delivery) {
    final statusColor = delivery.status == 'PENDING'
        ? Colors.orange
        : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.truck, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delivery.sekolahNama ?? 'Unknown School',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${delivery.jumlahTray} trays • ${delivery.jumlahKeranjang} baskets',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              delivery.status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockAlerts(
    BuildContext context,
    DapurDashboardController controller,
  ) {
    if (controller.lowStockItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Iconsax.warning_2, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text(
              'Low Stock Alerts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.lowStockCount.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),
        ...controller.lowStockItems
            .take(3)
            .map((item) => _buildStockAlertCard(item)),
      ],
    );
  }

  Widget _buildStockAlertCard(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.box, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Category: ${item.kategori}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.stokKg.toStringAsFixed(1)} kg',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
