import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_checkpoint_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';
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
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    // Adaptive Colors
    late Color backgroundColor;
    late Color borderColor;
    late double borderWidth;
    late bool showButton;
    late bool showShadow;

    switch (status) {
      case 'completed':
        backgroundColor = isDarkMode ? MBGColors.dark : MBGColors.light;
        borderColor = isDarkMode
            ? MBGColors.lightGrey.withValues(alpha: 0.4)
            : MBGColors.grey;
        borderWidth = 1;
        showButton = false;
        showShadow = false;
        break;

      case 'active':
        backgroundColor = MBGColors.primary.withValues(alpha: 0.08);
        borderColor = MBGColors.primary;
        borderWidth = 2;
        showButton = true;
        showShadow = true;
        break;

      case 'future':
      default:
        backgroundColor = isDarkMode
            ? MBGColors.darkContainer
            : MBGColors.lightContainer;
        borderColor = isDarkMode
            ? MBGColors.lightGrey.withValues(alpha: 0.2)
            : MBGColors.softGrey;
        borderWidth = 1;
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
                  color: MBGColors.primary.withValues(alpha: 0.12),
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
          // Header
          DapurCheckpointEventCardHeader(tipe: tipe, status: status),

          // Completed: Detail
          if (status == 'completed' && checkpoint != null) ...[
            const SizedBox(height: MBGSizes.spaceBtwItems / 2),

            if (checkpoint?.fotoUrl != null)
              DapurCheckpointEventCardImage(imageUrl: checkpoint!.fotoUrl!),

            if (checkpoint!.deskripsi != null) ...[
              const SizedBox(height: MBGSizes.spaceBtwItems / 2),
              DapurCheckpointEventCardDescription(
                description: checkpoint!.deskripsi!,
                status: status,
              ),
            ],

            const SizedBox(height: MBGSizes.spaceBtwItems / 2),
            DapurCheckpointEventCardTimestamp(
              timestamp: checkpoint!.timestamp!,
              durasi: checkpoint!.durasi,
            ),
          ],

          // Active/Future Description
          if ((status == 'active' || status == 'future') &&
              checkpoint?.deskripsi != null) ...[
            const SizedBox(height: MBGSizes.md),
            DapurCheckpointEventCardDescription(
              description: checkpoint!.deskripsi!,
              status: status,
            ),
          ],

          // Button only for active
          if (showButton) ...[
            const SizedBox(height: MBGSizes.md),
            DapurCheckpointEventCardActionButton(tipe: tipe),
          ],
        ],
      ),
    );
  }
}
