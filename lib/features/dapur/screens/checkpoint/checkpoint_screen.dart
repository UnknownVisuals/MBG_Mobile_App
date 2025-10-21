import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/menu_planning_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'widgets/checkpoint_empty_state_widget.dart';
import 'widgets/checkpoint_menu_list_widget.dart';
import 'widgets/checkpoints_view_widget.dart';

class CheckpointScreen extends StatelessWidget {
  const CheckpointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckpointController());
    final menuController = Get.put(MenuPlanningController());

    return Scaffold(
      body: Obx(() {
        // Fetch today's menus from menu planning
        final todayMenus = menuController.menuHarians
            .where((menu) => _isToday(menu.tanggal))
            .toList();

        return Column(
          children: [
            // Header
            Padding(
              padding: MBGSpacingStyles.homeScreenPadding,
              child: Row(
                children: [
                  Icon(Iconsax.camera, size: 32, color: MBGColors.primary),
                  const SizedBox(width: MBGSizes.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checkpoints',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Track cooking progress',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content
            Expanded(
              child: todayMenus.isEmpty
                  ? const CheckpointEmptyStateWidget()
                  : Row(
                      children: [
                        // Left: Menu List
                        Expanded(
                          flex: 2,
                          child: CheckpointMenuListWidget(
                            controller: controller,
                            menus: todayMenus,
                          ),
                        ),

                        // Right: Checkpoints
                        Expanded(
                          flex: 3,
                          child: CheckpointsViewWidget(
                            controller: controller,
                            onAddCheckpoint: (menuId) =>
                                _showAddCheckpointDialog(
                                  context,
                                  controller,
                                  menuId,
                                ),
                            onPhotoTap: (photoUrl) =>
                                _showPhotoDialog(context, photoUrl),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _showPhotoDialog(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Checkpoint Photo'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Image.network(
              photoUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: Icon(
                  Icons.broken_image,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCheckpointDialog(
    BuildContext context,
    CheckpointController controller,
    String menuHarianId,
  ) {
    String? selectedType;
    File? selectedImage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Checkpoint'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkpoint Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Checkpoint Type',
                    prefixIcon: Icon(Iconsax.note),
                  ),
                  initialValue: selectedType,
                  items: controller.getCheckpointTypes().map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(controller.getCheckpointTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),

                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Photo Selection
                Text(
                  'Photo (Optional)',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: MBGSizes.sm),

                if (selectedImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          MBGSizes.borderRadiusMd,
                        ),
                        child: Image.file(
                          selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            selectedImage = null;
                          });
                        },
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final image = await controller
                                .pickImageFromCamera();
                            if (image != null) {
                              setState(() {
                                selectedImage = image;
                              });
                            }
                          },
                          icon: const Icon(Iconsax.camera),
                          label: const Text('Camera'),
                        ),
                      ),
                      const SizedBox(width: MBGSizes.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final image = await controller
                                .pickImageFromGallery();
                            if (image != null) {
                              setState(() {
                                selectedImage = image;
                              });
                            }
                          },
                          icon: const Icon(Iconsax.gallery),
                          label: const Text('Gallery'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedType == null
                  ? null
                  : () async {
                      final success = await controller.createCheckpoint(
                        menuHarianId: menuHarianId,
                        tipe: selectedType!,
                        foto: selectedImage,
                      );
                      if (success && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
