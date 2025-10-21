import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_harian_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

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
                        'Checkpoint',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Track cooking process with photos',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: todayMenus.isEmpty
                  ? _buildEmptyState(context)
                  : Row(
                      children: [
                        // Today's Menus List
                        Expanded(
                          flex: 2,
                          child: _buildMenuList(
                            context,
                            controller,
                            todayMenus,
                          ),
                        ),

                        // Checkpoints View
                        Expanded(
                          flex: 3,
                          child: _buildCheckpointsView(context, controller),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.calendar_remove, size: 80, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text('No Menus Today', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Create a menu planning for today to add checkpoints',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(
    BuildContext context,
    CheckpointController controller,
    List<MenuHarianModel> menus,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(MBGSizes.md),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          final isSelected = controller.selectedMenu.value?.id == menu.id;

          return Obx(
            () => Card(
              elevation: isSelected ? 4 : 1,
              color: isSelected ? MBGColors.primary.withOpacity(0.1) : null,
              margin: const EdgeInsets.only(bottom: MBGSizes.sm),
              child: ListTile(
                onTap: () => controller.selectMenu(menu),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MBGColors.primary
                        : MBGColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                  ),
                  child: Icon(
                    Iconsax.note,
                    color: isSelected ? Colors.white : MBGColors.primary,
                  ),
                ),
                title: Text(
                  menu.namaMenu,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${menu.jamMulaiMasak} - ${menu.jamSelesaiMasak}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Icon(
                  isSelected ? Iconsax.tick_circle5 : Iconsax.arrow_right_3,
                  color: isSelected ? MBGColors.primary : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCheckpointsView(
    BuildContext context,
    CheckpointController controller,
  ) {
    return Obx(() {
      if (controller.selectedMenu.value == null) {
        return _buildSelectMenuPrompt(context);
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
              color: MBGColors.primary.withOpacity(0.05),
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
                  onPressed: () => _showAddCheckpointDialog(
                    context,
                    controller,
                    controller.selectedMenu.value!.id,
                  ),
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
                ? _buildEmptyCheckpoints(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(MBGSizes.md),
                    itemCount: controller.checkpoints.length,
                    itemBuilder: (context, index) {
                      final checkpoint = controller.checkpoints[index];
                      return _buildCheckpointCard(context, checkpoint);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildSelectMenuPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.arrow_left, size: 60, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text('Select a Menu', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Choose a menu to add checkpoints',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCheckpoints(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.camera, size: 60, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'No Checkpoints Yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Add photos to track the cooking process',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckpointCard(BuildContext context, dynamic checkpoint) {
    return Card(
      margin: const EdgeInsets.only(bottom: MBGSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkpoint Type Header
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: _getCheckpointColor(checkpoint.tipe).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MBGSizes.borderRadiusMd),
                topRight: Radius.circular(MBGSizes.borderRadiusMd),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getCheckpointIcon(checkpoint.tipe),
                  color: _getCheckpointColor(checkpoint.tipe),
                ),
                const SizedBox(width: MBGSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Get.find<CheckpointController>().getCheckpointTypeName(
                          checkpoint.tipe,
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getCheckpointColor(checkpoint.tipe),
                            ),
                      ),
                      Text(
                        DateFormat(
                          'dd MMM yyyy, HH:mm',
                        ).format(checkpoint.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Photo
          if (checkpoint.foto != null)
            GestureDetector(
              onTap: () => _showPhotoDialog(context, checkpoint.foto!),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  checkpoint.foto!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getCheckpointIcon(String type) {
    switch (type) {
      case 'MULAI_MEMASAK':
        return Iconsax.timer_start;
      case 'SELESAI_MEMASAK':
        return Iconsax.tick_circle;
      case 'SELESAI_PACKING':
        return Iconsax.box;
      case 'KITCHEN_RECEIVED':
        return Iconsax.received;
      case 'WASHING_COMPLETE':
        return Iconsax.security;
      case 'SCHOOL_TO_DRIVER_RETURN':
        return Iconsax.truck_fast;
      case 'DRIVER_TO_KITCHEN':
        return Iconsax.home_2;
      default:
        return Iconsax.camera;
    }
  }

  Color _getCheckpointColor(String type) {
    switch (type) {
      case 'MULAI_MEMASAK':
        return Colors.blue;
      case 'SELESAI_MEMASAK':
        return Colors.green;
      case 'SELESAI_PACKING':
        return Colors.orange;
      case 'KITCHEN_RECEIVED':
        return Colors.purple;
      case 'WASHING_COMPLETE':
        return MBGColors.primary;
      case 'SCHOOL_TO_DRIVER_RETURN':
        return Colors.teal;
      case 'DRIVER_TO_KITCHEN':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
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
                  value: selectedType,
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
