import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/shadow_styles.dart';
import 'package:mbg_mobile_app/features/dapur/models/timeline_event_data.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class TimelineEventCard extends StatelessWidget {
  final TimelineEventData event;

  const TimelineEventCard({super.key, required this.event});

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        // Active card uses primary gradient like progress card
        gradient: event.isActive ? MBGColors.primaryGradient : null,
        color: event.isActive ? null : MBGColors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        border: Border.all(
          color: event.isActive ? MBGColors.primary : MBGColors.borderPrimary,
          width: event.isActive ? 2 : 1,
        ),
        boxShadow: event.isActive ? [MBGShadowStyles.primaryCardShadow] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: event.isActive
                        ? MBGColors.white
                        : MBGColors.textPrimary,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Iconsax.clock,
                    size: MBGSizes.iconSm,
                    color: event.isActive
                        ? MBGColors.white
                        : MBGColors.darkGrey,
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                  Text(
                    _formatTime(event.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: event.isActive
                          ? MBGColors.white
                          : MBGColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.sm),

          // Description
          Text(
            event.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: event.isActive
                  ? MBGColors.white.withValues(alpha: 0.9)
                  : MBGColors.darkerGrey,
            ),
          ),
          const SizedBox(height: MBGSizes.md),

          // Action button (only show if not completed)
          if (!event.isCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Handle completion action
                },
                icon: Icon(
                  Iconsax.task,
                  color: event.isActive ? MBGColors.primary : MBGColors.white,
                ),
                label: Text(
                  'Mulai Proses',
                  style: TextStyle(
                    color: event.isActive ? MBGColors.primary : MBGColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: event.isActive
                      ? MBGColors.white
                      : MBGColors.primary,
                  foregroundColor: event.isActive
                      ? MBGColors.primary
                      : MBGColors.white,
                ),
              ),
            )
          else
            // Completed badge
            Container(
              padding: const EdgeInsets.all(MBGSizes.xs),
              decoration: BoxDecoration(
                color: MBGColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                border: Border.all(
                  color: MBGColors.success.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.tick_circle5,
                    size: MBGSizes.iconSm,
                    color: MBGColors.success.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  Text(
                    'Selesai   ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: MBGColors.success.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
