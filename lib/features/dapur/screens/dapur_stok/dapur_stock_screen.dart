import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_stock_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_stok/widgets/dapur_stock_add.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_stok/widgets/dapur_stock_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class DapurStokScreen extends StatelessWidget {
  const DapurStokScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurStokController dapurStokController = Get.put(
      DapurStokController(),
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => dapurStokController.refreshStok(),
        child: const DapurStokCard(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const DapurStokAdd()),
        backgroundColor: MBGColors.primary,
        icon: const Icon(Iconsax.box_add, color: MBGColors.white),
        label: Text(
          'Tambah Stok',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: MBGColors.white),
        ),
      ),
    );
  }
}
