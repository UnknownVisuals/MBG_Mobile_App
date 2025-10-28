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
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class DapurKaryawanEdit extends StatefulWidget {
  const DapurKaryawanEdit({super.key, required this.karyawan});

  final KaryawanModel karyawan;

  @override
  State<DapurKaryawanEdit> createState() => _DapurKaryawanEditState();
}

class _DapurKaryawanEditState extends State<DapurKaryawanEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CameraController _cameraController;
  late final DapurKaryawanController _karyawanController;
  late final TextEditingController _namaController;
  late final TextEditingController _posisiController;

  @override
  void initState() {
    super.initState();
    _cameraController = Get.put(CameraController());
    _karyawanController = Get.find<DapurKaryawanController>();

    _namaController = TextEditingController(text: widget.karyawan.nama);
    _posisiController = TextEditingController(text: widget.karyawan.posisi);

    // Ensure previous selections don't leak into edit flow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cameraController.clearImage();
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _posisiController.dispose();
    _cameraController.clearImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Form Edit Karyawan Dapur',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                MBGSectionHeading(title: 'Data Karyawan'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Karyawan',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) => MBGValidator.validateRequired(
                    value,
                    fieldName: 'Nama karyawan',
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: _posisiController,
                  decoration: const InputDecoration(
                    labelText: 'Posisi',
                    prefixIcon: Icon(Iconsax.briefcase),
                  ),
                  validator: (value) =>
                      MBGValidator.validateRequired(value, fieldName: 'Posisi'),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                Obx(
                  () => MBGSectionHeading(
                    title: 'Foto Karyawan',
                    showActionButton: _cameraController.hasImage,
                    actionButtonTitle: 'Hapus Foto Baru',
                    onPressed: () => _cameraController.clearImage(),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                Obx(() {
                  final bool dark = MBGHelperFunctions.isDarkMode(context);
                  final bool hasImage = _cameraController.hasImage;
                  final File? selectedImage = _cameraController.imageFile;

                  final bool hasExistingPhoto =
                      widget.karyawan.fotoUrl.isNotEmpty;

                  return GestureDetector(
                    onTap: hasImage
                        ? () => MBGImagePreviewDialog.showFile(
                            context: context,
                            imageFile: selectedImage!,
                          )
                        : () =>
                              MBGImagePickerBottomSheet.show(context: context),
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
                        child: hasImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MBGSizes.borderRadiusMd,
                                ),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : hasExistingPhoto
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MBGSizes.borderRadiusMd,
                                ),
                                child: Image.network(
                                  widget.karyawan.fotoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: MBGColors.grey.withValues(
                                        alpha: 0.3,
                                      ),
                                      child: const Icon(
                                        Iconsax.image,
                                        size: MBGSizes.iconLg,
                                        color: MBGColors.grey,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(MBGSizes.md),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Iconsax.image,
                                      size: MBGSizes.iconLg,
                                      color: MBGColors.grey,
                                    ),
                                    const SizedBox(height: MBGSizes.sm),
                                    Text(
                                      'Belum ada foto tersimpan',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: MBGSizes.sm),
                Text(
                  'Jika tidak memilih foto baru, foto saat ini akan tetap digunakan.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MBGColors.textSecondary,
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                Obx(() {
                  final bool hasImage = _cameraController.hasImage;
                  final bool hasExistingPhoto =
                      widget.karyawan.fotoUrl.isNotEmpty;
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              MBGImagePickerBottomSheet.show(context: context),
                          child: Text(
                            hasImage ? 'Pilih Ulang Foto' : 'Pilih Foto Baru',
                          ),
                        ),
                      ),
                      const SizedBox(width: MBGSizes.spaceBtwItems),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: hasImage
                              ? () => _cameraController.clearImage()
                              : hasExistingPhoto
                              ? () => MBGImagePreviewDialog.showData(
                                  context: context,
                                  imageData: widget.karyawan.fotoUrl,
                                )
                              : null,
                          child: Text(
                            hasImage
                                ? 'Batalkan Foto Baru'
                                : 'Lihat Foto Saat Ini',
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _karyawanController.isLoading.value
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              await _karyawanController.updateKaryawan(
                                karyawanId: widget.karyawan.id,
                                nama: _namaController.text.trim(),
                                posisi: _posisiController.text.trim(),
                                foto: _cameraController.hasImage
                                    ? _cameraController.imageFile!
                                    : null,
                              );
                            },
                      child: _karyawanController.isLoading.value
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
                          : const Text('Simpan Perubahan'),
                    ),
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
