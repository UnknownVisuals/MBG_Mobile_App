import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_siswa_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class SekolahSiswaDelete extends StatelessWidget {
  const SekolahSiswaDelete({super.key, required this.siswa});

  final SekolahSiswaModel siswa;

  static Future<bool?> show({
    required BuildContext context,
    required SekolahSiswaModel siswa,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Siswa'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${siswa.nama ?? 'siswa ini'}"?',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus Siswa'),
      content: Text(
        'Apakah Anda yakin ingin menghapus ${siswa.nama ?? 'siswa ini'}?',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: MBGColors.error),
          onPressed: () => Get.back(result: true),
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
