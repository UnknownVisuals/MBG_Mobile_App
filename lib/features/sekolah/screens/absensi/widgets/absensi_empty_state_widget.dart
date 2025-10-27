import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';

/// Empty state widget when no classes are available
class AbsensiEmptyStateWidget extends StatelessWidget {
  const AbsensiEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.buildings,
            size: 64,
            color: MBGColors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Classes Available',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: MBGColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create classes to record attendance',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: MBGColors.grey),
          ),
        ],
      ),
    );
  }
}
