import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';

/// Prompt widget to select a planning
class SelectPlanningPromptWidget extends StatelessWidget {
  const SelectPlanningPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.arrow_left, size: 60, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'Select a Menu Plan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Choose a week to view daily menus',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
