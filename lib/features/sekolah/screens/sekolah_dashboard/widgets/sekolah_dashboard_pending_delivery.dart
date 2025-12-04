import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_dashboard_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_delivery_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

/// Widget untuk menampilkan daftar pengiriman yang masih pending (UI Only)
class SekolahDashboardPendingDelivery extends StatelessWidget {
  const SekolahDashboardPendingDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SekolahDashboardController>();
    final dark = MBGHelperFunctions.isDarkMode(context);

    return Obx(() {
      final deliveries = controller.pendingDeliveries;

      if (deliveries.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(MBGSizes.md),
        decoration: BoxDecoration(
          color: dark ? MBGColors.dark : MBGColors.white,
          borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
          boxShadow: [
            if (!dark)
              BoxShadow(
                color: MBGColors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
          ],
          border: Border.all(
            color: dark ? MBGColors.darkerGrey : MBGColors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Header ===
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MBGColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.truck_fast,
                    color: MBGColors.warning,
                    size: 22,
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Text(
                  'Menunggu Driver',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: dark ? MBGColors.white : MBGColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // === List pengiriman real ===
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deliveries.length,
              separatorBuilder: (context, index) =>
                  Divider(color: dark ? MBGColors.darkerGrey : MBGColors.grey),
              itemBuilder: (context, index) {
                final delivery = deliveries[index];
                return _PendingItem(
                  name: 'Pengiriman #${delivery.qrCodeId}',
                  status: delivery.statusLabel,
                  icon:
                      delivery.normalizedStatus ==
                          SekolahDeliveryStatus.inTransit
                      ? Iconsax.truck_fast
                      : Iconsax.timer_1,
                  color: delivery.statusColor,
                  dark: dark,
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

/// Item kecil untuk tiap pengiriman pending
class _PendingItem extends StatelessWidget {
  final String name;
  final String status;
  final IconData icon;
  final Color color;
  final bool dark;

  const _PendingItem({
    required this.name,
    required this.status,
    required this.icon,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        name,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: dark ? MBGColors.white : MBGColors.textPrimary,
        ),
      ),
      subtitle: Text(
        status,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Iconsax.arrow_right_3,
        size: 18,
        color: dark ? MBGColors.darkGrey : MBGColors.darkGrey,
      ),
    );
  }
}
