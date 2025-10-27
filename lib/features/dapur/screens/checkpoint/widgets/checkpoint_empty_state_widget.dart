import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';

/// Empty state widget when no menus exist for today
class CheckpointEmptyStateWidget extends StatelessWidget {
  const CheckpointEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.calendar_remove, size: 80, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text('No Menus Today', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Create a menu planning for today to add checkpoints',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
