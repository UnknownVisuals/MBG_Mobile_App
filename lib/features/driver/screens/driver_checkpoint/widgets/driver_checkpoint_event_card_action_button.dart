import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_add.dart';

class DriverCheckpointEventCardActionButton extends StatelessWidget {
  const DriverCheckpointEventCardActionButton({super.key, required this.tipe});

  final String tipe;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final UserController userController = Get.find<UserController>();
    final DapurCheckpointController checkpointController =
        Get.find<DapurCheckpointController>();

    return Obx(() {
      final userRole = userController.userModel.value?.role;
      final canPerform =
          userRole != null &&
          checkpointController.canUserPerformCheckpoint(userRole, tipe);

      return canPerform
          ? _buildActionButton(context, scheme)
          : _buildLockedState(context, scheme);
    });
  }

  // ------------------------------------------------------------
  //  Locked State (Adaptive Light / Dark)
  // ------------------------------------------------------------
  Widget _buildLockedState(BuildContext context, ColorScheme scheme) {
    final Color error = scheme.error;
    final Color errorContainer = scheme.errorContainer;
    final Color onError = scheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.all(MBGSizes.fontSizeSm),
      decoration: BoxDecoration(
        color: errorContainer.withValues(
          alpha: scheme.brightness == Brightness.dark ? 0.22 : 0.18,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
        border: Border.all(color: error.withValues(alpha: 0.35), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Iconsax.lock, size: MBGSizes.iconSm + 4, color: error),
          const SizedBox(width: MBGSizes.md - 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akses Ditolak',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Anda tidak memiliki izin untuk melakukan checkpoint ini.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: onError.withValues(alpha: 0.85),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  //  Action Button
  // ------------------------------------------------------------
  Widget _buildActionButton(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => Get.to(DapurCheckpointAdd(checkpointType: tipe)),
        icon: Icon(Iconsax.play_circle, size: MBGSizes.iconSm + 4),
        label: Text(
          'Mulai Proses',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: MBGSizes.fontSizeSm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
          ),
        ),
      ),
    );
  }
}
