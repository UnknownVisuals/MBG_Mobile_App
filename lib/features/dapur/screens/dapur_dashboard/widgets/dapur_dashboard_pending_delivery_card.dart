import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Delivery card widget for pending deliveries
class DapurDashboardDeliveryCardWidget extends StatelessWidget {
  const DapurDashboardDeliveryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delivery = {
      'sekolahNama': 'SD Negeri 01 Jakarta',
      'jumlahTray': 10,
      'jumlahKeranjang': 5,
      'status': 'PENDING',

    };

    final statusColor = delivery['status'] == 'PENDING'
        ? MBGColors.warning
        : MBGColors.info;

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
               color: statusColor.withOpacity(0.12),
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
                  delivery['sekolahNama'].toString(),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${delivery['jumlahTray']} trays • ${delivery['jumlahKeranjang']} baskets',
                  style: theme.textTheme.bodySmall?.copyWith(
                     color: theme.hintColor,
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
              delivery['status'].toString(),
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
