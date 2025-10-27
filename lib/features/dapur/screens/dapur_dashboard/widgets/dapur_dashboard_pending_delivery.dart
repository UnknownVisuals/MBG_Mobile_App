import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_dashboard_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/widgets/dapur_dashboard_pending_delivery_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurDashboardPendingDelivery extends StatelessWidget {
  const DapurDashboardPendingDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    DapurDashboardController controller = Get.put(DapurDashboardController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MBGSectionHeading(
          showLeadingIcon: true,
          leadingIcon: Iconsax.truck,
          title: 'Pending Deliveries',
          showActionButton: true,
          actionButtonTitle: '${controller.pendingDeliveries.length} pending',
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems / 2),

        // If no deliveries for today
        if (controller.pendingDeliveries.isEmpty)
          Container(
            padding: const EdgeInsets.all(MBGSizes.defaultSpace),
            decoration: BoxDecoration(
              color: MBGColors.light,
              border: Border.all(color: MBGColors.grey),
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            ),
            child: Center(
              child: Text(
                'All deliveries completed',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MBGColors.textSecondary,
                ),
              ),
            ),
          )
        // Pending Deliveries List
        else
          ...controller.pendingDeliveries.map(
            (delivery) => DapurDashboardDeliveryCardWidget(delivery: delivery),
          ),
      ],
    );
  }
}
