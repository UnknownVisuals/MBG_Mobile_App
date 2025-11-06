import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_add.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_checkpoint_controller.dart';

class DriverCheckpointEventCardActionButton extends StatelessWidget {
  const DriverCheckpointEventCardActionButton({super.key, required this.tipe});

  final String tipe;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final DriverCheckpointController checkpointController =
        Get.find<DriverCheckpointController>();

    return Obx(() {
      final userRole = userController.userModel.value?.role;
      final canPerform =
          userRole != null &&
          checkpointController.canUserPerformCheckpoint(userRole, tipe);

      if (!canPerform) {
        // Show locked state if user doesn't have permission
        return Container(
          padding: const EdgeInsets.all(MBGSizes.fontSizeSm),
          decoration: BoxDecoration(
            color: MBGColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm + 6),
            border: Border.all(color: MBGColors.error.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.lock,
                size: MBGSizes.iconSm + 4,
                color: MBGColors.error,
              ),
              const SizedBox(width: MBGSizes.md - 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akses Ditolak',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MBGColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Anda tidak memiliki izin untuk melakukan checkpoint ini',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MBGColors.error.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      // Show action button if user has permission
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => Get.to(DapurCheckpointAdd(checkpointType: tipe)),
          style: ElevatedButton.styleFrom(
            backgroundColor: MBGColors.primary,
            foregroundColor: MBGColors.white,
            padding: const EdgeInsets.symmetric(vertical: MBGSizes.fontSizeSm),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm + 6),
            ),
          ),
          icon: Icon(Iconsax.play_circle, size: MBGSizes.iconSm + 4),
          label: Text(
            'Mulai Proses',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }
}
