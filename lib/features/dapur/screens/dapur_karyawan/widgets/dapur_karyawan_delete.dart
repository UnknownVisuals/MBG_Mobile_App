import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_karyawan_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Dialog widget for confirming employee deletion
class DapurKaryawanDelete extends StatelessWidget {
  const DapurKaryawanDelete({super.key, required this.karyawan});

  final DapurKaryawanModel karyawan;

  @override
  Widget build(BuildContext context) {
    final DapurKaryawanController dapurKaryawanController =
        Get.find<DapurKaryawanController>();

    return AlertDialog(
      title: const Text('Hapus Karyawan'),
      content: Text(
        'Apakah Anda yakin ingin menghapus ${karyawan.nama}? Tindakan ini tidak dapat dibatalkan.',
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Batal',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),

            const SizedBox(width: MBGSizes.spaceBtwItems),

            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await dapurKaryawanController.deleteKaryawan(
                    karyawanId: karyawan.id,
                  );
                },
                child: Text(
                  'Hapus',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
