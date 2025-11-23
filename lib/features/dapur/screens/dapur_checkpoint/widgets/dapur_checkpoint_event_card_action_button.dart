import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_add.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';

class DapurCheckpointEventCardActionButton extends StatelessWidget {
  const DapurCheckpointEventCardActionButton({super.key, required this.tipe});

  final String tipe;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final DapurCheckpointController checkpointController =
        Get.find<DapurCheckpointController>();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Define colors based on theme
    final errorColor = theme.colorScheme.error;
    final backgroundColor = isDark ? Colors.grey[800] : Colors.grey[100];
    final buttonColor = theme.colorScheme.primary;
    final buttonTextColor = theme.colorScheme.onPrimary;

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
            color: errorColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm + 6),
            border: Border.all(color: errorColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.lock,
                size: MBGSizes.iconSm + 4,
                color: errorColor,
              ),
              const SizedBox(width: MBGSizes.md - 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akses Ditolak',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Anda tidak memiliki izin untuk melakukan checkpoint ini',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: errorColor.withOpacity(0.8),
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
            backgroundColor: buttonColor,
            foregroundColor: buttonTextColor,
            padding: const EdgeInsets.symmetric(vertical: MBGSizes.fontSizeSm),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm + 6),
            ),
          ),
          icon: Icon(Iconsax.play_circle, size: MBGSizes.iconSm + 4),
          label: Text(
            'Mulai Proses',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: buttonTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }
}
