import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_karyawan_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_karyawan/widgets/dapur_karyawan_add.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_karyawan/widgets/dapur_karyawan_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurKaryawanScreen extends StatelessWidget {
  const DapurKaryawanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurKaryawanController dapurKaryawanController = Get.put(
      DapurKaryawanController(),
    );

    return Scaffold(
      body: Obx(() {
        if (dapurKaryawanController.isLoading.value &&
            dapurKaryawanController.karyawanList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: MBGColors.primary),
          );
        }

        if (dapurKaryawanController.karyawanList.isEmpty) {
          return RefreshIndicator(
            color: MBGColors.primary,
            onRefresh: dapurKaryawanController.refreshKaryawan,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.profile_2user,
                    size: MBGSizes.iconLg * 2,
                    color: MBGColors.textSecondary,
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  Text(
                    'Tidak ada karyawan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: MBGColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Tambahkan karyawan baru dengan menekan tombol di bawah',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: MBGColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: MBGColors.primary,
          onRefresh: dapurKaryawanController.refreshKaryawan,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const crossAxisCount = 2;
              final horizontalPadding = MBGSizes.defaultSpace * 2;
              final totalSpacing =
                  (crossAxisCount - 1) * MBGSizes.gridViewSpacing;
              final itemWidth =
                  (constraints.maxWidth - horizontalPadding - totalSpacing) /
                  crossAxisCount;

              final imageHeight = itemWidth * 5 / 4;
              const detailsHeight = 180.0; // Estimated text + action height
              final itemHeight = imageHeight + detailsHeight;
              final childAspectRatio = itemWidth / itemHeight;

              return GridView.builder(
                padding: const EdgeInsets.all(MBGSizes.defaultSpace),
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: MBGSizes.gridViewSpacing,
                  mainAxisSpacing: MBGSizes.gridViewSpacing,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: dapurKaryawanController.karyawanList.length,
                itemBuilder: (context, index) {
                  final karyawan = dapurKaryawanController.karyawanList[index];
                  return DapurKaryawanCard(karyawan: karyawan);
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(const DapurKaryawanAdd()),
        backgroundColor: MBGColors.primary,
        icon: Icon(Iconsax.profile_add, color: MBGColors.white),
        label: Text(
          'Tambah Karyawan',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: MBGColors.white),
        ),
      ),
    );
  }
}
