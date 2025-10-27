import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:intl/intl.dart';
import 'widgets/attendance_summary_widget.dart';
import 'widgets/sekolah_action_cards_widget.dart';
import 'widgets/sekolah_delivery_card_widget.dart';
import 'widgets/sekolah_menu_card_widget.dart';

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
                AttendanceSummaryWidget(controller: controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Stats Cards
                const SekolahActionCardsWidget(),
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
          ...controller.todaysMenus.map(
            (menu) => SekolahMenuCardWidget(menu: menu),
          ),
      ],
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
            (delivery) => SekolahDeliveryCardWidget(delivery: delivery),
          ),
      ],
    );
  }
}
