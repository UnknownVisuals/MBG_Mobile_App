import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_checkpoint_model.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_header.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_image.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_description.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_timestamp.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_action_button.dart';

class DapurCheckpointEventCard extends StatelessWidget {
  const DapurCheckpointEventCard({
    super.key,
    required this.tipe,
    required this.status,
    this.checkpoint,
  });

  final String tipe;
  final String status; // 'completed', 'active', 'future'
  final DapurCheckpointModel? checkpoint;

  @override
  Widget build(BuildContext context) {
    // Style based on status
    Color backgroundColor;
    Color borderColor;
    double borderWidth;
    Color textColor;
    Color iconColor;
    Color iconBackgroundColor;
    bool showButton;
    bool showShadow;

    switch (status) {
      case 'completed':
        // Normal appearance for completed tasks
        backgroundColor = MBGColors.light;
        borderColor = MBGColors.borderPrimary;
        borderWidth = 1;
        textColor = MBGColors.textPrimary;
        iconColor = MBGColors.success;
        iconBackgroundColor = MBGColors.success.withValues(alpha: 0.1);
        showButton = false;
        showShadow = false;
        break;
      case 'active':
        // Highlighted appearance for active task
        backgroundColor = MBGColors.primary.withValues(alpha: 0.08);
        borderColor = MBGColors.primary;
        borderWidth = 2;
        textColor = MBGColors.textPrimary;
        iconColor = MBGColors.primary;
        iconBackgroundColor = MBGColors.primary.withValues(alpha: 0.15);
        showButton = true;
        showShadow = true;
        break;
      case 'future':
      default:
        // Greyed out appearance for future tasks
        backgroundColor = MBGColors.softGrey;
        borderColor = MBGColors.grey;
        borderWidth = 1;
        textColor = MBGColors.darkGrey.withValues(alpha: 0.5);
        iconColor = MBGColors.grey;
        iconBackgroundColor = MBGColors.grey.withValues(alpha: 0.1);
        showButton = false;
        showShadow = false;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: MBGColors.primary.withValues(alpha: 0.1),
                  blurRadius: MBGSizes.sm,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(MBGSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header with icon, title, role badges, and status badge
          DapurCheckpointEventCardHeader(
            tipe: tipe,
            status: status,
            textColor: textColor,
            iconColor: iconColor,
            iconBackgroundColor: iconBackgroundColor,
          ),

          // Show details for completed checkpoint
          if (status == 'completed' && checkpoint != null) ...[
            const SizedBox(height: MBGSizes.spaceBtwItems / 2),
            // Photo if available
            if (checkpoint?.fotoUrl != null) ...[
              DapurCheckpointEventCardImage(imageUrl: checkpoint!.fotoUrl),
            ],

            // Description if available
            if (checkpoint!.deskripsi != null) ...[
              const SizedBox(height: MBGSizes.spaceBtwItems / 2),
              DapurCheckpointEventCardDescription(
                description: checkpoint!.deskripsi!,
                status: status,
              ),
            ],

            // Timestamp and Duration in cards
            const SizedBox(height: MBGSizes.spaceBtwItems / 2),
            DapurCheckpointEventCardTimestamp(
              timestamp: checkpoint!.timestamp,
              durasi: checkpoint!.durasi,
            ),
          ],

          // Show description for active and future checkpoints
          if ((status == 'active' || status == 'future') &&
              checkpoint?.deskripsi != null) ...[
            const SizedBox(height: MBGSizes.md),
            DapurCheckpointEventCardDescription(
              description: checkpoint!.deskripsi!,
              status: status,
            ),
          ],

          // Show button for active checkpoint
          if (showButton) ...[
            const SizedBox(height: MBGSizes.md),
            DapurCheckpointEventCardActionButton(tipe: tipe),
          ],
        ],
      ),
    );
  }
}
