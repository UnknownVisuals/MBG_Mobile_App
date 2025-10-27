import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// No assigned kitchen widget
class EmptyDapurDashboard extends StatelessWidget {
  final DapurDashboardController controller;
  final String? errorMessage;

  const EmptyDapurDashboard({
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
