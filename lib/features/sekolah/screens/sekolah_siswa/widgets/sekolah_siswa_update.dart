import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/image_picker_bottom_sheet.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_siswa_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_siswa_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class SekolahSiswaUpdate extends StatefulWidget {
  const SekolahSiswaUpdate({super.key, required this.siswa});

  final SekolahSiswaModel siswa;

  @override
  State<SekolahSiswaUpdate> createState() => _SekolahSiswaUpdateState();
}

class _SekolahSiswaUpdateState extends State<SekolahSiswaUpdate> {
  late final TextEditingController namaController;
  late final TextEditingController nisController;
  late final TextEditingController umurController;
  late final TextEditingController tinggiController;
  late final TextEditingController beratController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxnString selectedJenisKelamin = RxnString();
  final RxnString selectedKelasId = RxnString();
  late final CameraController cameraController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.siswa.nama);
    nisController = TextEditingController(text: widget.siswa.nis);
    umurController = TextEditingController(text: widget.siswa.umur?.toString());
    tinggiController = TextEditingController(
      text: widget.siswa.tinggiBadan?.toString(),
    );
    beratController = TextEditingController(
      text: widget.siswa.beratBadan?.toString(),
    );
    selectedJenisKelamin.value = widget.siswa.jenisKelamin ?? 'LAKI_LAKI';
    selectedKelasId.value = widget.siswa.kelasId;
    cameraController = Get.isRegistered<CameraController>()
        ? Get.find()
        : Get.put(CameraController());
  }

  @override
  void dispose() {
    namaController.dispose();
    nisController.dispose();
    umurController.dispose();
    tinggiController.dispose();
    beratController.dispose();
    super.dispose();
  }

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

    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        padding: MBGSpacingStyles.homeScreenPadding,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perbarui informasi siswa',
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
                  initialValue: selectedJenisKelamin.value,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kelamin',
                    prefixIcon: Icon(Iconsax.user_tag),
                  ),
                  items: ['LAKI_LAKI', 'PEREMPUAN'].map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) => selectedJenisKelamin.value = value,
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              Obx(() {
                final kelasList = kelasController.kelasList;
                return DropdownButtonFormField<String>(
                  initialValue: selectedKelasId.value,
                  decoration: const InputDecoration(
                    labelText: 'Kelas',
                    prefixIcon: Icon(Iconsax.buildings),
                  ),
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
                  showActionButton:
                      cameraController.selectedImage.value != null,
                  actionButtonTitle: 'Hapus Gambar',
                  onPressed: cameraController.selectedImage.value != null
                      ? cameraController.clearImage
                      : null,
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),

              Obx(
                () => GestureDetector(
                  onTap: () {
                    if (cameraController.selectedImage.value == null) {
                      MBGImagePickerBottomSheet.show(context: context);
                    } else {
                      MBGImagePreviewDialog.showFile(
                        context: context,
                        imageFile: cameraController.selectedImage.value!,
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
                      child: cameraController.selectedImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                MBGSizes.borderRadiusMd,
                              ),
                              child: Image.file(
                                cameraController.selectedImage.value!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : (widget.siswa.fotoUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      MBGSizes.borderRadiusMd,
                                    ),
                                    child: InteractiveViewer(
                                      child: Image.network(
                                        widget.siswa.fotoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) =>
                                            const Icon(Iconsax.gallery),
                                      ),
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
                                          'Tidak ada foto',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: MBGColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  )),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      (cameraController.selectedImage.value != null ||
                          (widget.siswa.fotoUrl != null &&
                              widget.siswa.fotoUrl!.isNotEmpty))
                      ? () => MBGImagePickerBottomSheet.show(context: context)
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

                    final kelasId =
                        selectedKelasId.value ?? widget.siswa.kelasId;

                    final umur = int.tryParse(umurController.text.trim());
                    final tinggi = double.tryParse(
                      tinggiController.text.trim(),
                    );
                    final berat = double.tryParse(beratController.text.trim());

                    if (umur == null || tinggi == null || berat == null) {
                      MBGLoaders.errorSnackBar(
                        title: 'Format Angka Salah',
                        message:
                            'Periksa kembali kolom umur, tinggi, dan berat.',
                      );
                      return;
                    }

                    await controller.updateSiswa(
                      siswaId: widget.siswa.id,
                      nama: namaController.text.trim(),
                      nis: nisController.text.trim(),
                      jenisKelamin: selectedJenisKelamin.value ?? 'LAKI_LAKI',
                      umur: umur,
                      tinggiBadan: tinggi,
                      beratBadan: berat,
                      kelasId: kelasId,
                      foto: cameraController.selectedImage.value,
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
