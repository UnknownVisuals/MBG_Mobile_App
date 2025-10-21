import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverDashboardController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.pendingDeliveries.isEmpty) {
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

                // Stats Cards
                _buildStatsCards(controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Quick Action - QR Scanner
                _buildQuickAction(context),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Pending Deliveries
                _buildPendingDeliveries(context, controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Recent Deliveries
                _buildRecentDeliveries(context, controller),
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
          'Driver Dashboard',
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

  Widget _buildStatsCards(DriverDashboardController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Iconsax.truck_fast,
            label: 'Pending',
            value: controller.pendingCount.value.toString(),
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Expanded(
          child: _buildStatCard(
            icon: Iconsax.tick_circle,
            label: 'Today',
            value: controller.completedTodayCount.value.toString(),
            color: Colors.green,
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Expanded(
          child: _buildStatCard(
            icon: Iconsax.box,
            label: 'Total',
            value: controller.totalDeliveriesCount.value.toString(),
            color: MBGColors.primary,
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
      padding: const EdgeInsets.all(MBGSizes.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/driver/qr-scanner'),
      child: Container(
        padding: const EdgeInsets.all(MBGSizes.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MBGColors.primary, MBGColors.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
          boxShadow: [
            BoxShadow(
              color: MBGColors.primary.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Iconsax.scan_barcode,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Scan delivery QR to update status',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingDeliveries(
    BuildContext context,
    DriverDashboardController controller,
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
            if (controller.pendingCount.value > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.pendingCount.value}',
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
          ...controller.pendingDeliveries.map(
            (delivery) => _buildDeliveryCard(delivery, true),
          ),
      ],
    );
  }

  Widget _buildRecentDeliveries(
    BuildContext context,
    DriverDashboardController controller,
  ) {
    if (controller.completedDeliveries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Deliveries',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),
        ...controller.completedDeliveries
            .take(5)
            .map((delivery) => _buildDeliveryCard(delivery, false)),
      ],
    );
  }

  Widget _buildDeliveryCard(delivery, bool isPending) {
    final statusColor = isPending ? Colors.orange : Colors.green;
    final statusIcon = isPending ? Iconsax.clock : Iconsax.tick_circle;

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
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
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(delivery.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
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
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                Iconsax.box,
                '${delivery.jumlahTray} Trays',
                MBGColors.primary,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Iconsax.bag,
                '${delivery.jumlahKeranjang} Baskets',
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
