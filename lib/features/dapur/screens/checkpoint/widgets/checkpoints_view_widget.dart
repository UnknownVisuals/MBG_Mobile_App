import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/checkpoint_controller.dart';
import 'checkpoint_card_widget.dart';
import 'empty_checkpoints_widget.dart';
import 'select_menu_prompt_widget.dart';

/// Checkpoints view section showing list or empty states
class CheckpointsViewWidget extends StatelessWidget {
  final CheckpointController controller;
  final Function(String menuId) onAddCheckpoint;
  final Function(String photoUrl) onPhotoTap;

  const CheckpointsViewWidget({
    super.key,
    required this.controller,
    required this.onAddCheckpoint,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedMenu.value == null) {
        return const SelectMenuPromptWidget();
      }

      if (controller.isLoadingCheckpoints.value &&
          controller.checkpoints.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: MBGColors.primary.withValues(alpha: 0.05),
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.selectedMenu.value!.namaMenu,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${controller.checkpoints.length} checkpoints',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      onAddCheckpoint(controller.selectedMenu.value!.id),
                  icon: const Icon(Iconsax.camera, size: 18),
                  label: const Text('Add Checkpoint'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MBGColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Checkpoints List
          Expanded(
            child: controller.checkpoints.isEmpty
                ? const EmptyCheckpointsWidget()
                : ListView.builder(
                    padding: const EdgeInsets.all(MBGSizes.md),
                    itemCount: controller.checkpoints.length,
                    itemBuilder: (context, index) {
                      final checkpoint = controller.checkpoints[index];
                      return CheckpointCardWidget(
                        checkpoint: checkpoint,
                        onPhotoTap: () => onPhotoTap(checkpoint.foto!),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
