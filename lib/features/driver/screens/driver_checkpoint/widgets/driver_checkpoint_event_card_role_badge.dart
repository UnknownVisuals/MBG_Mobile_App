import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';

class DriverCheckpointEventCardRoleBadge extends StatelessWidget {
  const DriverCheckpointEventCardRoleBadge({super.key, required this.tipe});

  final String tipe;

  @override
  Widget build(BuildContext context) {
    final DapurCheckpointController checkpointController =
        Get.find<DapurCheckpointController>();

    return Wrap(
      spacing: MBGSizes.xs,
      runSpacing: MBGSizes.xs,
      children: checkpointController.getCheckpointRoles(tipe).map((role) {
        final roleColor = checkpointController.getRoleColor(role);
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: MBGSizes.sm,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: roleColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(MBGSizes.cardRadiusXs),
            border: Border.all(
              color: roleColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                role == 'DRIVER' ? Iconsax.driving : Iconsax.user_octagon,
                size: MBGSizes.iconXs,
                color: roleColor,
              ),
              const SizedBox(width: MBGSizes.xs),
              Text(
                checkpointController.getRoleDisplayName(role),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: roleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
