import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';
import 'package:mbg_mobile_app/common/widgets/image_picker_bottom_sheet.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_karyawan_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class DapurKaryawanAdd extends StatelessWidget {
  const DapurKaryawanAdd({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependencies
    final DapurKaryawanController dapurKaryawanController =
        Get.find<DapurKaryawanController>();
    final CameraController cameraController =
        Get.isRegistered<CameraController>()
        ? Get.find<CameraController>()
        : Get.put(CameraController());

    // Form Controllers
    final TextEditingController nameController = TextEditingController();
    final TextEditingController positionController = TextEditingController();
    final RxnString selectedJenisKelamin = RxnString();
    final TextEditingController ageController = TextEditingController();
    final Rx<File?> selectedImage = cameraController.selectedImage;

    // Form Key
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Title
                Text(
                  'Form Tambah Karyawan Dapur',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Data Karyawan Section
                MBGSectionHeading(title: 'Data Karyawan'),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Nama
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Karyawan',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) {
                    return MBGValidator.validateRequired(
                      value,
                      fieldName: 'Nama Karyawan',
                    );
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Posisi
                TextFormField(
                  controller: positionController,
                  decoration: const InputDecoration(
                    labelText: 'Posisi',
                    prefixIcon: Icon(Iconsax.briefcase),
                  ),
                  validator: (value) {
                    return MBGValidator.validateRequired(
                      value,
                      fieldName: 'Posisi',
                    );
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Jenis Kelamin Dropdown
                Obx(
                  () => DropdownButtonFormField<JenisKelamin>(
                    initialValue: selectedJenisKelamin.value != null
                        ? JenisKelamin.values.firstWhere(
                            (e) => e.name == selectedJenisKelamin.value,
                          )
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      prefixIcon: Icon(Iconsax.user_tag),
                    ),
                    items: JenisKelamin.values.map((jenisKelamin) {
                      return DropdownMenuItem(
                        value: jenisKelamin,
                        child: Text(jenisKelamin.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedJenisKelamin.value = value?.name;
                    },
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Umur
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Umur',
                    prefixIcon: Icon(Iconsax.calendar),
                  ),
                  validator: (value) {
                    return MBGValidator.validateRequired(
                      value,
                      fieldName: 'Umur',
                    );
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Foto Karyawan Section
                Obx(() {
                  return MBGSectionHeading(
                    title: 'Foto Karyawan',
                    showActionButton: selectedImage.value != null,
                    actionButtonTitle: 'Hapus Gambar',
                    onPressed: selectedImage.value != null
                        ? () => cameraController.clearImage()
                        : null,
                  );
                }),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Image Picker
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (selectedImage.value == null) {
                        MBGImagePickerBottomSheet.show(context: context);
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
                          color: MBGColors.lightContainer,
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
                                    color: MBGColors.darkGrey,
                                  ),
                                  const SizedBox(height: MBGSizes.sm),
                                  Text(
                                    'Ketuk untuk mengunggah foto',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: MBGColors.darkGrey),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Action Buttons
                Obx(
                  () => Row(
                    children: [
                      // Ubah Foto Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: selectedImage.value != null
                              ? () => MBGImagePickerBottomSheet.show(
                                  context: context,
                                )
                              : null,
                          child: const Text('Ubah Foto'),
                        ),
                      ),
                      const SizedBox(width: MBGSizes.spaceBtwItems),

                      // Submit Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate Form
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            // Validate Image
                            if (selectedImage.value == null) {
                              MBGLoaders.errorSnackBar(
                                title: 'Foto Karyawan Kosong',
                                message:
                                    'Silakan unggah foto karyawan terlebih dahulu',
                              );
                              return;
                            }

                            // Process the form data
                            await dapurKaryawanController.addKaryawan(
                              nama: nameController.text.trim(),
                              posisi: positionController.text.trim(),
                              jenisKelamin: selectedJenisKelamin.value!,
                              umur: int.tryParse(ageController.text.trim())!,
                              foto: selectedImage.value!,
                            );
                          },
                          child: const Text('Kirim'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
