import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/image_picker_bottom_sheet.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurCheckpointAdd extends StatelessWidget {
  const DapurCheckpointAdd({super.key, required this.checkpointType});

  final String checkpointType;

  @override
  Widget build(BuildContext context) {
    // Dependencies
    final CameraController cameraController =
        Get.isRegistered<CameraController>()
        ? Get.find<CameraController>()
        : Get.put(CameraController());
    final DapurCheckpointController checkpointController =
        Get.find<DapurCheckpointController>();

    final isDark = MBGHelperFunctions.isDarkMode(context);

    // Form Controllers
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final Rx<File?> selectedImage = cameraController.selectedImage;
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Title
                Text(
                  'Form Checkpoint',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Form Fields
                const MBGSectionHeading(title: 'Informasi Checkpoint'),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Type Checkpoint (Read-only)
                TextFormField(
                  initialValue: checkpointController.getCheckpointLabel(
                    checkpointType,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Tipe Checkpoint',
                    prefixIcon: Icon(
                      checkpointController.getCheckpointIcon(checkpointType),
                    ),
                    enabled: false,
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Description
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    prefixIcon: Icon(Iconsax.note_text),
                    hintText: 'Masukkan deskripsi checkpoint...',
                  ),
                  validator: (value) {
                    return MBGValidator.validateRequired(
                      value,
                      fieldName: 'Deskripsi',
                    );
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Form Fields
                const MBGSectionHeading(title: 'Bukti Foto'),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Image Picker
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (selectedImage.value == null) {
                        MBGImagePickerBottomSheet.show(
                          context: context,
                          addWatermark: true,
                        );
                      } else {
                        MBGImagePreviewDialog.showFile(
                          context: context,
                          imageFile: selectedImage.value!,
                        );
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: 5 / 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            MBGSizes.borderRadiusMd,
                          ),
                          border: Border.all(color: MBGColors.borderPrimary),
                          color: isDark
                              ? MBGColors.darkContainer
                              : MBGColors.lightContainer,
                        ),
                        child: selectedImage.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MBGSizes.borderRadiusMd,
                                ),
                                child: Image.file(
                                  selectedImage.value!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.image,
                                    size: MBGSizes.iconLg * 1.5,
                                    color: isDark
                                        ? MBGColors.darkGrey
                                        : MBGColors.darkGrey,
                                  ),
                                  const SizedBox(height: MBGSizes.sm),
                                  Text(
                                    'Ketuk untuk mengunggah foto',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: isDark
                                              ? MBGColors.textSecondary
                                              : MBGColors.darkGrey,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.md),
          child: Obx(
            () => Row(
              children: [
                // Ubah Foto Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: selectedImage.value != null
                        ? () => MBGImagePickerBottomSheet.show(
                            context: context,
                            addWatermark: true,
                          )
                        : null,
                    child: const Text('Ubah Foto'),
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),

                // Submit Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: checkpointController.isLoading.value
                        ? null
                        : () async {
                            // Validate form
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            // Check if image is selected
                            if (selectedImage.value == null) {
                              Get.snackbar(
                                'Error',
                                'Silakan pilih foto terlebih dahulu',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: MBGColors.error,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            // Get menuHarianId from controller
                            final menuHarianId =
                                checkpointController.currentMenuHarianId.value;

                            if (menuHarianId == null) {
                              Get.snackbar(
                                'Error',
                                'Menu Harian tidak ditemukan',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: MBGColors.error,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            // Create checkpoint
                            await checkpointController.createCheckpoint(
                              menuHarianId: menuHarianId,
                              tipe: checkpointType,
                              foto: selectedImage.value!,
                              deskripsi: descriptionController.text.trim(),
                            );

                            // Clear image and form only on success
                            // Note: Controller navigates back on success, so this might not be needed
                            // but good for safety if we stay on page (which we don't)
                            cameraController.clearImage();
                            descriptionController.clear();
                          },
                    child: const Text('Kirim'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
