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
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_karyawan_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurKaryawanEdit extends StatelessWidget {
  const DapurKaryawanEdit({super.key, required this.karyawan});

  final DapurKaryawanModel karyawan;

  @override
  Widget build(BuildContext context) {
    // Selected Values for Dropdowns
    final Rx<KaryawanStatus?> selectedStatus = Rx<KaryawanStatus?>(null);
    final Rx<JenisKelamin?> selectedGender = Rx<JenisKelamin?>(null);
    selectedStatus.value = karyawan.status;
    selectedGender.value = karyawan.jenisKelamin;

    final DapurKaryawanController dapurKaryawanController =
        Get.find<DapurKaryawanController>();

    // Camera Controller
    final CameraController cameraController =
        Get.isRegistered<CameraController>()
        ? Get.find<CameraController>()
        : Get.put(CameraController());
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
                  'Form Edit Karyawan Dapur',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Data Karyawan Section
                MBGSectionHeading(title: 'Data Karyawan'),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Nama
                TextFormField(
                  initialValue: karyawan.nama,
                  decoration: const InputDecoration(
                    labelText: 'Nama Karyawan',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Posisi
                TextFormField(
                  initialValue: karyawan.posisi,
                  decoration: const InputDecoration(
                    labelText: 'Posisi',
                    prefixIcon: Icon(Iconsax.briefcase),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Status
                Obx(
                  () => DropdownButtonFormField<KaryawanStatus>(
                    initialValue: selectedStatus.value,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      prefixIcon: Icon(Iconsax.status),
                    ),
                    items: KaryawanStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedStatus.value = value;
                    },
                  ),
                ),

                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Jenis Kelamin
                Obx(
                  () => DropdownButtonFormField<JenisKelamin>(
                    initialValue: selectedGender.value,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      prefixIcon: Icon(Iconsax.user_tag),
                    ),
                    items: JenisKelamin.values.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedGender.value = value;
                    },
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Umur
                TextFormField(
                  initialValue: karyawan.umur?.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Umur',
                    prefixIcon: Icon(Iconsax.calendar),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Foto Karyawan Section
                const MBGSectionHeading(title: 'Foto Karyawan'),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Image Picker
                Obx(() {
                  final File? localImage = selectedImage.value;
                  final String? remoteImage = karyawan.fotoUrl;
                  final bool hasLocalImage = localImage != null;
                  final bool hasRemoteImage =
                      !hasLocalImage &&
                      remoteImage != null &&
                      remoteImage.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      if (hasLocalImage) {
                        MBGImagePreviewDialog.showFile(
                          context: context,
                          imageFile: localImage,
                        );
                      } else if (hasRemoteImage) {
                        MBGImagePreviewDialog.showData(
                          context: context,
                          imageData: remoteImage,
                        );
                      } else {
                        MBGImagePickerBottomSheet.show(context: context);
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
                        child: hasLocalImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MBGSizes.borderRadiusMd,
                                ),
                                child: Image.file(
                                  localImage,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : hasRemoteImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MBGSizes.borderRadiusMd,
                                ),
                                child: Image.network(
                                  remoteImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Iconsax.image,
                                          size: MBGSizes.iconLg * 1.5,
                                          color: MBGColors.darkGrey,
                                        ),
                                        const SizedBox(height: MBGSizes.sm),
                                        Text(
                                          'Gagal memuat gambar',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: MBGColors.darkGrey,
                                              ),
                                        ),
                                      ],
                                    );
                                  },
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
                  );
                }),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                const SizedBox(height: MBGSizes.spaceBtwSections * 2),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.spaceBtwItems),
          child: Obx(
            () => Row(
              children: [
                // Ubah Gambar Button
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        (selectedImage.value != null ||
                            (karyawan.fotoUrl != null &&
                                karyawan.fotoUrl!.isNotEmpty))
                        ? () => MBGImagePickerBottomSheet.show(context: context)
                        : null,
                    child: const Text('Ubah Foto'),
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),

                // Simpan Perubahan Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate Form
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      // Process the form data
                      await dapurKaryawanController.updateKaryawan(
                        karyawanId: karyawan.id,
                        nama: karyawan.nama,
                        posisi: karyawan.posisi,
                        status: selectedStatus.value,
                        jenisKelamin: selectedGender.value,
                        foto: selectedImage.value,
                      );
                    },
                    child: const Text('Simpan'),
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
