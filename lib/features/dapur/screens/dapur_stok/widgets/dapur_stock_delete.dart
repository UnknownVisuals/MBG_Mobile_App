import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_stock_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stock_model.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurStokDeleteDialog extends StatelessWidget {
  const DapurStokDeleteDialog({super.key, required this.stok});

  final DapurStokModel stok;

  @override
  Widget build(BuildContext context) {
    DapurStokController dapurStokController = Get.find<DapurStokController>();

    return AlertDialog(
      title: Text(
        'Konfirmasi Hapus',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Text('Apakah Anda yakin ingin menghapus stok "${stok.nama}"?'),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(width: MBGSizes.spaceBtwItems),
            Expanded(
              child: ElevatedButton(
                onPressed: () => dapurStokController.deleteStok(stok.id),
                child: const Text('Hapus'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
