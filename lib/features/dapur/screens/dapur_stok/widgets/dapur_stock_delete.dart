import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stok_model.dart';

class DapurStockDeleteDialog extends StatelessWidget {
  const DapurStockDeleteDialog({super.key, required this.stok});

  final StokModel stok;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Konfirmasi Hapus',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Text(
        'Apakah Anda yakin ingin menghapus stok "${stok.nama}"?',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Get.back(result: false),
          child: Text('Batal', style: Theme.of(context).textTheme.labelMedium),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          child: Text('Hapus', style: Theme.of(context).textTheme.labelMedium),
        ),
      ],
    );
  }
}
