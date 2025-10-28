import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/image_picker_bottom_sheet.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_karyawan_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class DapurKaryawanAdd extends StatelessWidget {
  const DapurKaryawanAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final CameraController cameraController = Get.put(CameraController());
    final DapurKaryawanController karyawanController =
        Get.find<DapurKaryawanController>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController namaController = TextEditingController();
    final TextEditingController posisiController = TextEditingController();

    // Clear selected image when this widget is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cameraController.clearImage();
    });

    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  'Form Tambah Karyawan Dapur',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                MBGSectionHeading(title: 'Data Karyawan'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                TextFormField(
                  controller: namaController,
                  expands: false,
                  decoration: InputDecoration(
                    labelText: 'Nama Karyawan',
                    prefixIcon: const Icon(Iconsax.user),
                  ),
                  validator: (value) => MBGValidator.validateRequired(
                    value,
                    fieldName: 'Nama karyawan',
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: posisiController,
                  expands: false,
                  decoration: InputDecoration(
                    labelText: 'Posisi',
                    prefixIcon: const Icon(Iconsax.briefcase),
                  ),
                  validator: (value) =>
                      MBGValidator.validateRequired(value, fieldName: 'Posisi'),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Upload Picture Section
                Obx(
                  () => MBGSectionHeading(
                    title: 'Upload Foto Karyawan',
                    showActionButton: cameraController.hasImage,
                    actionButtonTitle: 'Hapus Foto',
                    onPressed: () {
                      cameraController.clearImage();
                    },
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                Obx(() {
                  final dark = MBGHelperFunctions.isDarkMode(context);

                  return GestureDetector(
                    onTap: () {
                      if (!cameraController.hasImage) {
                        MBGImagePickerBottomSheet.show(context: context);
                      } else {
                        MBGImagePreviewDialog.showFile(
                          context: context,
                          imageFile: cameraController.imageFile!,
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
                          border: Border.all(
                            color: dark
                                ? MBGColors.darkGrey
                                : MBGColors.borderPrimary,
                          ),
                          color: dark
                              ? MBGColors.darkContainer
                              : MBGColors.lightContainer,
                        ),
                        child: cameraController.hasImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MBGSizes.borderRadiusMd,
                                ),
                                child: Image.file(
                                  cameraController.imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.image,
                                    size: MBGSizes.iconLg * 1.5,
                                    color: dark
                                        ? MBGColors.grey
                                        : MBGColors.darkGrey,
                                  ),
                                  const SizedBox(height: MBGSizes.sm),
                                  Text(
                                    'Ketuk untuk mengunggah foto',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: dark
                                              ? MBGColors.grey
                                              : MBGColors.darkGrey,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }),

                SizedBox(height: MBGSizes.spaceBtwSections),

                // Action Buttons
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: cameraController.hasImage
                              ? () => MBGImagePickerBottomSheet.show(
                                  context: context,
                                )
                              : null,
                          child: Text('Ubah Foto'),
                        ),
                      ),
                      const SizedBox(width: MBGSizes.spaceBtwItems),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: karyawanController.isLoading.value
                              ? null
                              : () async {
                                  // Validate form
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }

                                  // Validate image
                                  if (!cameraController.hasImage) {
                                    MBGLoaders.errorSnackBar(
                                      title: 'Foto Diperlukan',
                                      message: 'Silakan unggah foto karyawan',
                                    );
                                    return;
                                  }

                                  // Submit data
                                  await karyawanController.addKaryawan(
                                    nama: namaController.text.trim(),
                                    posisi: posisiController.text.trim(),
                                    foto: cameraController.imageFile!,
                                  );
                                },
                          child: karyawanController.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text('Kirim'),
                        ),
                      ),
                    ],
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
