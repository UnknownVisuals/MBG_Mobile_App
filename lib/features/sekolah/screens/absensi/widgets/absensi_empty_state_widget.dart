import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Empty state widget when no classes are available
class AbsensiEmptyStateWidget extends StatelessWidget {
  const AbsensiEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.buildings,
            size: 64,
            color: colors.onSurfaceVariant.withOpacity(0.4),
          ),
          const SizedBox(height: 16),

          // TITLE
          Text(
            'No Classes Available',
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          // SUBTITLE
          Text(
            'Create classes to record attendance',
            style: text.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
