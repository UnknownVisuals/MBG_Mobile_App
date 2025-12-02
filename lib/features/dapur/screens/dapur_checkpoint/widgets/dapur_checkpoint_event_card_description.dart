import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurCheckpointEventCardDescription extends StatelessWidget {
  const DapurCheckpointEventCardDescription({
    super.key,
    required this.description,
    required this.status,
  });

  final String description;
  final String status; // 'completed', 'active', 'future'

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == 'completed';
    final bool isActive = status == 'active';
    final bool isDark = MBGHelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MBGSizes.md,
        vertical: MBGSizes.sm,
      ),
      decoration: BoxDecoration(
        color: isCompleted
            ? (isDark ? MBGColors.darkContainer : MBGColors.softGrey)
            : isActive
            ? MBGColors.primary.withValues(alpha: 0.05)
            : (isDark ? MBGColors.darkContainer : MBGColors.softGrey),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
        border: isCompleted
            ? null
            : Border.all(
                color: isActive
                    ? MBGColors.primary.withValues(alpha: 0.2)
                    : (isDark
                          ? MBGColors.borderPrimary
                          : MBGColors.grey.withValues(alpha: 0.3)),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCompleted ? Iconsax.message_text : Iconsax.info_circle,
            size: MBGSizes.iconMd,
            color: isCompleted
                ? (isDark ? MBGColors.white : MBGColors.darkGrey)
                : isActive
                ? MBGColors.primary
                : MBGColors.grey,
          ),
          const SizedBox(width: MBGSizes.spaceBtwItems / 2),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isCompleted
                    ? (isDark ? MBGColors.white : MBGColors.textPrimary)
                    : isActive
                    ? (isDark ? MBGColors.white : MBGColors.textPrimary)
                    : (isDark
                          ? MBGColors.darkGrey
                          : MBGColors.darkGrey.withValues(alpha: 0.5)),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
