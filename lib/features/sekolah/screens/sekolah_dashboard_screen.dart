import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

class SekolahDashboardScreen extends StatelessWidget {
  const SekolahDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SekolahDashboardController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.todaysAbsensi.isEmpty) {
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

                // Attendance Summary Card
                _buildAttendanceSummary(context, controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Stats Cards
                _buildStatsCards(controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Today's Menu
                _buildTodaysMenu(context, controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Pending Deliveries
                _buildPendingDeliveries(context, controller),
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
          'School Dashboard',
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

  Widget _buildAttendanceSummary(
    BuildContext context,
    SekolahDashboardController controller,
  ) {
    final statusColor = controller.getAttendanceStatusColor();

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.user_tick,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Today\'s Attendance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (controller.attendanceRate.value > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.attendanceRate.value.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildWhiteStatCard(
                  label: 'Present',
                  value: controller.totalPresentToday.value.toString(),
                  icon: Iconsax.user_tick,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWhiteStatCard(
                  label: 'Classes',
                  value: controller.totalClassesToday.value.toString(),
                  icon: Iconsax.teacher,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(SekolahDashboardController controller) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Get.toNamed('/sekolah/absensi'),
            child: _buildStatCard(
              icon: Iconsax.clipboard_text,
              label: 'Record Attendance',
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Expanded(
          child: InkWell(
            onTap: () => Get.toNamed('/sekolah/qr-scanner'),
            child: _buildStatCard(
              icon: Iconsax.scan_barcode,
              label: 'Scan Delivery',
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
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
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysMenu(
    BuildContext context,
    SekolahDashboardController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Menu',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
              child: Column(
                children: [
                  Icon(Iconsax.note, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'No menu available for today',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MBGColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.note, color: MBGColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week ${menu.mingguanKe}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('dd MMM').format(menu.tanggalMulai)} - ${DateFormat('dd MMM yyyy').format(menu.tanggalSelesai)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingDeliveries(
    BuildContext context,
    SekolahDashboardController controller,
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
            if (controller.pendingDeliveriesCount.value > 0)
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
          ...controller.pendingDeliveries.map(
            (delivery) => _buildDeliveryCard(delivery),
          ),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.truck, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery from Kitchen',
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
}
