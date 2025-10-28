import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_stock_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_stok/widgets/dapur_stock_add.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_stok/widgets/dapur_stock_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_stok/widgets/empty_dapur_stock_screen.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class DapurStockScreen extends StatelessWidget {
  const DapurStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurStockController stokController = Get.put(DapurStockController());
    final DapurController dapurController = Get.find<DapurController>();

    return Obx(() {
      final selectedDapur = dapurController.selectedDapur.value;
      final isKitchenLoading = dapurController.isDapurLoading.value;
      final errorMessage = dapurController.dapurError.value;

      if (isKitchenLoading && selectedDapur == null) {
        return const Center(
          child: CircularProgressIndicator(color: MBGColors.primary),
        );
      }

      if (selectedDapur == null) {
        return StokNoDapurSelectedWidget(errorMessage: errorMessage);
      }

      return Stack(
        children: [
          Scaffold(
            body: const DapurStockCard(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => Get.to(() => const DapurStockAdd()),
              backgroundColor: MBGColors.primary,
              icon: const Icon(Iconsax.box_add, color: MBGColors.white),
              label: Text(
                'Tambah Stok',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MBGColors.white),
              ),
            ),
          ),
          if (stokController.isSaving.value)
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
