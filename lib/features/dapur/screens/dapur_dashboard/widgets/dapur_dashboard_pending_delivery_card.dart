import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurDashboardDeliveryCard extends StatelessWidget {
  const DapurDashboardDeliveryCard({super.key, required this.delivery});

  final DapurPengirimanModel delivery;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    final status = delivery.status?.toUpperCase() ?? 'UNKNOWN';
    final sekolahNama = delivery.sekolah?.nama ?? 'Unknown School';
    final trayCount = delivery.jumlahTray ?? 0;
    final keranjangCount = delivery.jumlahKeranjang ?? 0;

    final Color statusColor = status == 'PENDING'
        ? MBGColors.warning
        : status == 'PROSES'
        ? MBGColors.info
        : MBGColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: isDarkMode ? MBGColors.dark : MBGColors.light,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(
          color: isDarkMode
              ? MBGColors.lightGrey.withValues(alpha: 0.4)
              : MBGColors.darkGrey.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
            ),
            child: Icon(Iconsax.truck, color: statusColor),
          ),

          const SizedBox(width: MBGSizes.spaceBtwItems),

          // Delivery Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sekolahNama,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$trayCount trays • $keranjangCount baskets',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: MBGSizes.spaceBtwItems / 2),

          // Status Tag
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.md,
              vertical: MBGSizes.sm,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
            ),
            child: Text(
              status,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
