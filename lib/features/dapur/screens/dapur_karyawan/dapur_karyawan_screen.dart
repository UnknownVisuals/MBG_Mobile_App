import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_karyawan_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_karyawan/widgets/dapur_karyawan_add.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

import 'widgets/dapur_karyawan_card.dart';

class DapurKaryawanScreen extends StatelessWidget {
  const DapurKaryawanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurKaryawanController dapurKaryawanController = Get.put(
      DapurKaryawanController(),
    );

    return Obx(() {
      final isLoading = dapurKaryawanController.isLoading.value;
      final hasData = dapurKaryawanController.karyawanList.isNotEmpty;

      if (isLoading && !hasData) {
        return const Center(
          child: CircularProgressIndicator(color: MBGColors.primary),
        );
      }

      return Stack(
        children: [
          Scaffold(
            body: const DapurKaryawanCard(),
            floatingActionButton: Container(
              decoration: const BoxDecoration(
                color: MBGColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Get.to(const DapurKaryawanAdd()),
                icon: const Icon(Iconsax.profile_add, color: MBGColors.white),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.2),
                child: const Center(
                  child: CircularProgressIndicator(color: MBGColors.primary),
                ),
              ),
            ),
        ],
      );
    });
  }
}
