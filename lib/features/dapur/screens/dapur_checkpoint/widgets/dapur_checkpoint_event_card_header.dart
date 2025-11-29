import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_role_badge.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_status_badge.dart';

class DapurCheckpointEventCardHeader extends StatelessWidget {
  const DapurCheckpointEventCardHeader({
    super.key,
    required this.tipe,
    required this.status,
  });

  final String tipe;
  final String status;

  @override
  Widget build(BuildContext context) {
    final DapurCheckpointController checkpointController =
        Get.find<DapurCheckpointController>();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ---- WARNA ADAPTIF DARI THEME ----
    final Color textColor = theme.colorScheme.onSurface;
    final Color iconColor = theme.colorScheme.primary;
    final Color iconBackgroundColor = isDark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
        : theme.colorScheme.primary.withValues(alpha: 0.1);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(MBGSizes.sm),
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
          ),
          child: Icon(
            checkpointController.getCheckpointIcon(tipe),
            size: MBGSizes.iconMd,
            color: iconColor,
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems / 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                checkpointController.getCheckpointLabel(tipe),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              DapurCheckpointEventCardRoleBadge(tipe: tipe),
            ],
          ),
        ),
        if (status == 'completed') const DapurCheckpointEventCardStatusBadge(),
      ],
    );
  }
}
