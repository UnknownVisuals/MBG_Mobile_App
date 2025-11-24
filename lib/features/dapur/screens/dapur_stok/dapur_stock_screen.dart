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
    final DapurStokController dapurStokController =
        Get.put(DapurStokController());

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: () => dapurStokController.refreshStok(),
        child: const DapurStokCard(),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const DapurStokAdd()),

        /// Tetap memakai warna branding MBG, tapi pastikan teks ikonnya adaptif
        backgroundColor: MBGColors.primary,
        foregroundColor: theme.colorScheme.onPrimary,

        icon: Icon(
          Iconsax.box_add,
          color: theme.colorScheme.onPrimary,
        ),

        label: Text(
          'Tambah Stok',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
