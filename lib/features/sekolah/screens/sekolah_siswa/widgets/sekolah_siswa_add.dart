import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/image_picker_bottom_sheet.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_siswa_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class SekolahSiswaAdd extends StatelessWidget {
  const SekolahSiswaAdd({super.key});

  static const List<String> _jenisKelaminOptions = ['LAKI_LAKI', 'PEREMPUAN'];

  @override
  Widget build(BuildContext context) {
    final SekolahSiswaController controller =
        Get.isRegistered<SekolahSiswaController>()
        ? Get.find()
        : Get.put(SekolahSiswaController());
    final SekolahKelasController kelasController =
        Get.isRegistered<SekolahKelasController>()
        ? Get.find()
        : Get.put(SekolahKelasController());
    final CameraController cameraController =
        Get.isRegistered<CameraController>()
        ? Get.find()
        : Get.put(CameraController());

    final TextEditingController namaController = TextEditingController();
    final TextEditingController nisController = TextEditingController();
    final TextEditingController umurController = TextEditingController();
    final TextEditingController tinggiController = TextEditingController();
    final TextEditingController beratController = TextEditingController();
    final RxnString selectedJenisKelamin = RxnString('LAKI_LAKI');
    final RxnString selectedKelasId = RxnString();
    final Rx<File?> selectedImage = cameraController.selectedImage;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Siswa Sekolah'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: MBGSpacingStyles.homeScreenPadding,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lengkapi data siswa',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              const MBGSectionHeading(title: 'Data Siswa'),
              const SizedBox(height: MBGSizes.spaceBtwItems),

              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: (value) => MBGValidator.validateRequired(
                  value,
                  fieldName: 'Nama siswa',
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              TextFormField(
                controller: nisController,
                decoration: const InputDecoration(
                  labelText: 'NIS',
                  prefixIcon: Icon(Iconsax.hashtag),
                ),
                validator: (value) =>
                    MBGValidator.validateRequired(value, fieldName: 'NIS'),
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedJenisKelamin.value,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kelamin',
                    prefixIcon: Icon(Iconsax.user_tag),
                  ),
                  items: _jenisKelaminOptions.map((jenis) {
                    return DropdownMenuItem(value: jenis, child: Text(jenis));
                  }).toList(),
                  onChanged: (value) => selectedJenisKelamin.value = value,
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              Obx(() {
                final kelasList = kelasController.kelasList;
                return DropdownButtonFormField<String>(
                  value: selectedKelasId.value,
                  decoration: const InputDecoration(
                    labelText: 'Kelas',
                    prefixIcon: Icon(Iconsax.buildings),
                  ),
                  hint: const Text('Pilih kelas'),
                  items: kelasList.map((kelas) {
                    return DropdownMenuItem(
                      value: kelas.id,
                      child: Text(kelas.nama ?? 'Kelas'),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Pilih kelas terlebih dahulu' : null,
                  onChanged: (value) => selectedKelasId.value = value,
                );
              }),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              TextFormField(
                controller: umurController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Umur',
                  prefixIcon: Icon(Iconsax.calendar),
                ),
                validator: (value) =>
                    MBGValidator.validateRequired(value, fieldName: 'Umur'),
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              TextFormField(
                controller: tinggiController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tinggi Badan (cm)',
                  prefixIcon: Icon(Iconsax.chart),
                ),
                validator: (value) => MBGValidator.validateRequired(
                  value,
                  fieldName: 'Tinggi badan',
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              TextFormField(
                controller: beratController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Berat Badan (kg)',
                  prefixIcon: Icon(Iconsax.weight_1),
                ),
                validator: (value) => MBGValidator.validateRequired(
                  value,
                  fieldName: 'Berat badan',
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              Obx(
                () => MBGSectionHeading(
                  title: 'Foto Siswa',
                  showActionButton: selectedImage.value != null,
                  actionButtonTitle: 'Hapus Gambar',
                  onPressed: selectedImage.value != null
                      ? () => cameraController.clearImage()
                      : null,
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),

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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          MBGSizes.borderRadiusMd,
                        ),
                        border: Border.all(color: MBGColors.borderPrimary),
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
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.gallery,
                                    size: MBGSizes.iconLg,
                                    color: MBGColors.textSecondary,
                                  ),
                                  const SizedBox(
                                    height: MBGSizes.spaceBtwItems / 2,
                                  ),
                                  Text(
                                    'Ketuk untuk mengunggah foto',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: MBGColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              Obx(
                () => Row(
                  children: [
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
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          if (selectedImage.value == null) {
                            MBGLoaders.errorSnackBar(
                              title: 'Foto Kosong',
                              message:
                                  'Silakan unggah foto siswa terlebih dahulu.',
                            );
                            return;
                          }

                          final kelasId = selectedKelasId.value;
                          if (kelasId == null) {
                            MBGLoaders.errorSnackBar(
                              title: 'Kelas Belum Dipilih',
                              message: 'Pilih kelas terlebih dahulu.',
                            );
                            return;
                          }

                          final umur = int.tryParse(umurController.text.trim());
                          final tinggi = double.tryParse(
                            tinggiController.text.trim(),
                          );
                          final berat = double.tryParse(
                            beratController.text.trim(),
                          );

                          if (umur == null || tinggi == null || berat == null) {
                            MBGLoaders.errorSnackBar(
                              title: 'Format Angka Salah',
                              message:
                                  'Periksa kembali kolom umur, tinggi, dan berat.',
                            );
                            return;
                          }

                          await controller.createSiswa(
                            nama: namaController.text.trim(),
                            nis: nisController.text.trim(),
                            jenisKelamin:
                                selectedJenisKelamin.value ?? 'LAKI_LAKI',
                            umur: umur,
                            tinggiBadan: tinggi,
                            beratBadan: berat,
                            kelasId: kelasId,
                            foto: selectedImage.value!,
                          );
                        },
                        child: const Text('Kirim'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
