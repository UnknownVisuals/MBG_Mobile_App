import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';

/// Empty state widget for menu harian
class EmptyMenuHarianWidget extends StatelessWidget {
  const EmptyMenuHarianWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.note, size: 60, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'No Daily Menus',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Add daily menus for this week',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
