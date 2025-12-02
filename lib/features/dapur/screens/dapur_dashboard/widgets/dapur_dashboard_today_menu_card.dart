import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurDashboardTodayMenuCard extends StatelessWidget {
  const DapurDashboardTodayMenuCard({super.key, required this.menu});

  final DapurMenuHarianModel menu;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    // Format time range if available, otherwise just show date
    final timeString = menu.tanggal != null
        ? DateFormat(
            'EEEE, dd MMM yyyy',
            'id_ID',
          ).format(menu.tanggal!.toLocal())
        : 'Unknown Date';

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
              color: Colors.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
            ),
            child: const Icon(Iconsax.note, color: Colors.green),
          ),

          const SizedBox(width: MBGSizes.spaceBtwItems),

          // Menu Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.namaMenu ?? 'Unnamed Menu',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timeString,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: MBGSizes.spaceBtwItems / 2),

          // Price Tag (Assuming budget per porsi or similar, if available. For now showing static or removing)
          // Since model doesn't seem to have price, we can show something else or remove it.
          // Let's show "Active" or similar if needed, or just remove.
          // For now, I'll remove the price tag as it's not in the basic model I saw earlier.
        ],
      ),
    );
  }
}
