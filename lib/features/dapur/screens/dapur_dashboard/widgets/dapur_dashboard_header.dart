import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurDashboardHeader extends StatelessWidget {
  const DapurDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurController dapurController = Get.put(DapurController());
    final selectedDapur = dapurController.selectedDapur.value;
    final assignedDapur = dapurController.assignedDapur;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and Time Info
        Row(
          children: [
            // Date Info
            Icon(
              Iconsax.calendar,
              size: MBGSizes.iconSm,
              color: MBGColors.primary,
            ),
            const SizedBox(width: MBGSizes.spaceBtwItems / 2),
            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const Spacer(),

            // Time Info
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: MBGSizes.sm,
                vertical: MBGSizes.xs,
              ),
              decoration: BoxDecoration(
                color: MBGColors.primary.withValues(alpha: 0.2),
                border: Border.all(
                  color: MBGColors.primary.withValues(alpha: 0.8),
                ),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Text(
                DateFormat('HH:mm:ss').format(DateTime.now()),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: MBGColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: MBGSizes.spaceBtwItems),

        // Dapur Selection
        if (selectedDapur != null) ...[
          // If multiple dapur assigned, show dropdown
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
          // If only one dapur assigned, show static info
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.building,
                  size: MBGSizes.iconLg,
                  color: MBGColors.primary,
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDapur.nama,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        selectedDapur.alamat,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: MBGColors.textSecondary,
                        ),
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
}
