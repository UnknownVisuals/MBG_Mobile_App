import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/styles/spacing_styles.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/dapur_dashboard_controller.dart';

/// No assigned kitchen widget
class NoAssignedKitchenWidget extends StatelessWidget {
  final DapurDashboardController controller;
  final String? errorMessage;

  const NoAssignedKitchenWidget({
    super.key,
    required this.controller,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshDashboard,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: MBGSpacingStyles.homeScreenPadding,
        children: [
          const SizedBox(height: MBGSizes.spaceBtwSections * 2),
          Icon(Iconsax.warning_2, size: 64, color: Colors.grey[400]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'No kitchen assignment found for your account.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: MBGSizes.spaceBtwItems / 2),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.redAccent),
            ),
          ],
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'Pull to refresh or contact the administrator to request a kitchen assignment.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
