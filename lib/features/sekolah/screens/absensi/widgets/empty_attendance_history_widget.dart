import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';

/// Empty attendance history widget (theme-adaptive)
class EmptyAttendanceHistoryWidget extends StatelessWidget {
  const EmptyAttendanceHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.note,
            size: 60,
            color: colors.onSurfaceVariant.withOpacity(0.3), // adaptive
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          Text(
            'No Attendance Records',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: MBGSizes.sm),

          Text(
            'Start recording daily attendance',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant, // adaptive
            ),
          ),
        ],
      ),
    );
  }
}
