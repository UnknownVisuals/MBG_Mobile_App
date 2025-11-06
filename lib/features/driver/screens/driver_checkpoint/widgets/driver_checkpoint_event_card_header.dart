import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_role_badge.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card_status_badge.dart';

class DriverCheckpointEventCardHeader extends StatelessWidget {
  const DriverCheckpointEventCardHeader({
    super.key,
    required this.tipe,
    required this.status,
    required this.textColor,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  final String tipe;
  final String status;
  final Color textColor;
  final Color iconColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final DapurCheckpointController checkpointController =
        Get.find<DapurCheckpointController>();

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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              // Role badges
              DapurCheckpointEventCardRoleBadge(tipe: tipe),
            ],
          ),
        ),
        if (status == 'completed') const DapurCheckpointEventCardStatusBadge(),
      ],
    );
  }
}
