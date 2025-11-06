import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_pengiriman_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class DapurPengirimanDelete extends StatelessWidget {
  const DapurPengirimanDelete({
    super.key,
    required this.pengirimanId,
    required this.controller,
  });

  final String pengirimanId;
  final DapurPengirimanController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Konfirmasi Hapus',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: const Text(
        'Apakah Anda yakin ingin menghapus data pengiriman ini?',
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () async {
                          final success = await controller.deletePengiriman(
                            pengirimanId,
                          );
                          if (success) {
                            Get.back(); // Close dialog
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MBGColors.error,
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Hapus'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
