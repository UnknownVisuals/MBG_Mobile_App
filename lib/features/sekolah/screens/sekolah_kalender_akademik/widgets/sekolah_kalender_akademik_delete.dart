import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kalender_akademik_model.dart';

class SekolahKalenderAkademikDelete extends StatelessWidget {
  const SekolahKalenderAkademikDelete({super.key, required this.event});

  final SekolahKalenderAkademikModel event;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus Event'),
      content: Text(
        'Apakah Anda yakin ingin menghapus event "${event.deskripsi ?? 'ini'}"?',
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
    );
  }
}
