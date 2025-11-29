import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class SekolahKelasEdit extends StatelessWidget {
  const SekolahKelasEdit({super.key, required this.kelas});

  final SekolahKelasModel kelas;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SekolahKelasController>();

    final namaController = TextEditingController(text: kelas.nama ?? '');
    final tingkatController = TextEditingController(
      text: kelas.tingkat?.toString() ?? '',
    );

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: MBGAppBar(
        showBackArrow: true,
        title: const Text('Perbarui Kelas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Edit Kelas',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                MBGSectionHeading(title: 'Data Kelas'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kelas',
                    prefixIcon: Icon(Iconsax.buildings),
                  ),
                  validator: (value) => MBGValidator.validateRequired(
                    value,
                    fieldName: 'Nama Kelas',
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: tingkatController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tingkat',
                    prefixIcon: Icon(Iconsax.briefcase),
                  ),
                  validator: (value) {
                    final error = MBGValidator.validateRequired(
                      value,
                      fieldName: 'Tingkat',
                    );
                    if (error != null) return error;
                    final parsed = int.tryParse(value!.trim());
                    if (parsed == null) {
                      return 'Tingkat harus berupa angka bulat';
                    }
                    if (parsed < 1 || parsed > 12) {
                      return 'Tingkat harus antara 1 dan 12';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final tingkat = int.parse(tingkatController.text.trim());
                      await controller.updateKelas(
                        id: kelas.id,
                        nama: namaController.text.trim(),
                        tingkat: tingkat,
                      );
                    },
                    child: const Text('Simpan Perubahan'),
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
