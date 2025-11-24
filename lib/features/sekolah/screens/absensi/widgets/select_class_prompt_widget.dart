import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';

/// Select class prompt widget (theme-adaptive)
class SelectClassPromptWidget extends StatelessWidget {
  const SelectClassPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.arrow_left,
            size: 60,
            color: colors.onSurfaceVariant.withOpacity(0.3), // adaptive
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          Text(
            'Select a Class',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSurface, // visible in dark mode
            ),
          ),

          const SizedBox(height: MBGSizes.sm),

          Text(
            'Choose a class to view or record attendance',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant, // adaptive secondary text
            ),
          ),
        ],
      ),
    );
  }
}
