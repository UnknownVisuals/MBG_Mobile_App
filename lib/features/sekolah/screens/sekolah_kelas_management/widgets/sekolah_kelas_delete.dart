import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahKelasDeleteDialog extends StatelessWidget {
  const SekolahKelasDeleteDialog({super.key, required this.kelas});

  final SekolahKelasModel kelas;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SekolahKelasController>();

    return AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: Text('Hapus kelas "${kelas.nama ?? 'Kelas'}"?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () => controller.deleteKelas(kelas.id),
          child: const Text('Hapus'),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: MBGSizes.defaultSpace,
        vertical: MBGSizes.spaceBtwItems / 2,
      ),
    );
  }
}
