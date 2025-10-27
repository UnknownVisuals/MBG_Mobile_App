import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';

/// Empty state widget for menu planning
class MenuPlanningEmptyStateWidget extends StatelessWidget {
  const MenuPlanningEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.calendar, size: 80, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'No Menu Plans Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Create your first weekly menu plan',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
