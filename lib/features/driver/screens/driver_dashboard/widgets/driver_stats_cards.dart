import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Compact stats grid used on the driver dashboard.
class DriverStatsCards extends StatelessWidget {
  const DriverStatsCards({super.key, required this.controller});

  final DriverDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Iconsax.truck_fast,
            label: 'Pending',
            value: controller.pendingCount.value.toString(),
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Expanded(
          child: _StatCard(
            icon: Iconsax.tick_circle,
            label: 'Today',
            value: controller.completedTodayCount.value.toString(),
            color: Colors.green,
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Expanded(
          child: _StatCard(
            icon: Iconsax.box,
            label: 'Total',
            value: controller.totalDeliveriesCount.value.toString(),
            color: MBGColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
}
