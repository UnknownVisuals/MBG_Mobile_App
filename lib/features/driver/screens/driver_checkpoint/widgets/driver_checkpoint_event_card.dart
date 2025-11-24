import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_checkpoint_model.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_header.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_image.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_description.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_timestamp.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_action_button.dart';

class DriverCheckpointEventCard extends StatelessWidget {
  const DriverCheckpointEventCard({
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ==========================
    //   DEFINE ADAPTIVE COLORS
    // ==========================

    // Background adapts with theme
    Color backgroundColor;
    Color borderColor;
    double borderWidth;
    bool showButton;
    bool showShadow;

    switch (status) {
      case 'completed':
        backgroundColor = colorScheme.surface;
        borderColor = colorScheme.outlineVariant;
        borderWidth = 1;
        showButton = false;
        showShadow = false;
        break;

      case 'active':
        backgroundColor = colorScheme.primary.withOpacity(0.08);
        borderColor = colorScheme.primary;
        borderWidth = 2;
        showButton = true;
        showShadow = true;
        break;

      case 'future':
      default:
        backgroundColor = colorScheme.surfaceVariant.withOpacity(0.4);
        borderColor = colorScheme.outlineVariant;
        borderWidth = 1;
        showButton = false;
        showShadow = false;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.15),
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
          // ==========================
          //        HEADER
          // ==========================
          DapurCheckpointEventCardHeader(tipe: tipe, status: status),

          // ==========================
          //    COMPLETED CONTENT
          // ==========================
          if (status == 'completed' && checkpoint != null) ...[
            const SizedBox(height: MBGSizes.spaceBtwItems / 2),

            if (checkpoint?.fotoUrl != null)
              DapurCheckpointEventCardImage(imageUrl: checkpoint!.fotoUrl),

            if (checkpoint!.deskripsi != null) ...[
              const SizedBox(height: MBGSizes.spaceBtwItems / 2),
              DapurCheckpointEventCardDescription(
                description: checkpoint!.deskripsi!,
                status: status,
              ),
            ],

            const SizedBox(height: MBGSizes.spaceBtwItems / 2),
            DapurCheckpointEventCardTimestamp(
              timestamp: checkpoint!.timestamp,
              durasi: checkpoint!.durasi,
            ),
          ],

          // ==========================
          // ACTIVE / FUTURE DESCRIPTION
          // ==========================
          if ((status == 'active' || status == 'future') &&
              checkpoint?.deskripsi != null) ...[
            const SizedBox(height: MBGSizes.md),
            DapurCheckpointEventCardDescription(
              description: checkpoint!.deskripsi!,
              status: status,
            ),
          ],

          // ==========================
          //     ACTION BUTTON
          // ==========================
          if (showButton) ...[
            const SizedBox(height: MBGSizes.md),
            DapurCheckpointEventCardActionButton(tipe: tipe),
          ],
        ],
      ),
    );
  }
}
