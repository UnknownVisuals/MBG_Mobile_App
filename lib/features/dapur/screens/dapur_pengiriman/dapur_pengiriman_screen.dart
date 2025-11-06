import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/chip_filter.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_pengiriman_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_pengiriman/widgets/dapur_pengiriman_add.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_pengiriman/widgets/dapur_pengiriman_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_pengiriman/widgets/dapur_pengiriman_empty.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

/// Main pengiriman management screen - Dumb UI with hardcoded data
class DapurPengirimanScreen extends StatelessWidget {
  const DapurPengirimanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurPengirimanController dapurPengirimanController = Get.put(
      DapurPengirimanController(),
    );

    return Scaffold(
      body: Padding(
        padding: MBGSpacingStyles.homeScreenPadding,
        child: Column(
          children: [
            Obx(() {
              if (dapurPengirimanController.isLoading.value &&
                  dapurPengirimanController.sekolahList.isEmpty) {
                return const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              if (dapurPengirimanController.sekolahList.isEmpty) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Belum ada sekolah yang dilayani',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              final sekolahNama = dapurPengirimanController.sekolahNama ?? '';
              return InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Sekolah',
                  prefixIcon: Icon(Iconsax.building_3),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  sekolahNama,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // Chip Filter Section
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MBChipFilter(
                      chipFilterString:
                          'Semua (${dapurPengirimanController.totalCount})',
                      chipFilterColor: Colors.blue,
                      chipFilterIcon: Iconsax.category,
                      isSelected:
                          dapurPengirimanController.selectedFilter.value ==
                          'all',
                      onTap: () => dapurPengirimanController.setFilter('all'),
                    ),
                    const SizedBox(width: MBGSizes.spaceBtwItems),
                    MBChipFilter(
                      chipFilterString:
                          'Pending (${dapurPengirimanController.pendingCount})',
                      chipFilterColor: Colors.orange,
                      chipFilterIcon: Iconsax.clock,
                      isSelected:
                          dapurPengirimanController.selectedFilter.value ==
                          'pending',
                      onTap: () =>
                          dapurPengirimanController.setFilter('pending'),
                    ),
                    const SizedBox(width: MBGSizes.spaceBtwItems),
                    MBChipFilter(
                      chipFilterString:
                          'Dikirim (${dapurPengirimanController.inTransitCount})',
                      chipFilterColor: Colors.purple,
                      chipFilterIcon: Iconsax.truck_fast,
                      isSelected:
                          dapurPengirimanController.selectedFilter.value ==
                          'in_transit',
                      onTap: () =>
                          dapurPengirimanController.setFilter('in_transit'),
                    ),
                    const SizedBox(width: MBGSizes.spaceBtwItems),
                    MBChipFilter(
                      chipFilterString:
                          'Selesai (${dapurPengirimanController.completedCount})',
                      chipFilterColor: Colors.green,
                      chipFilterIcon: Iconsax.tick_circle,
                      isSelected:
                          dapurPengirimanController.selectedFilter.value ==
                          'completed',
                      onTap: () =>
                          dapurPengirimanController.setFilter('completed'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // List Section
            Expanded(
              child: Obx(() {
                if (dapurPengirimanController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final list = dapurPengirimanController.filteredPengiriman;
                if (list.isEmpty) {
                  return const DapurPengirimanEmpty();
                }

                return RefreshIndicator(
                  onRefresh: dapurPengirimanController.refreshPengiriman,
                  color: MBGColors.primary,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final pengiriman = list[index];
                      return DapurPengirimanCard(pengiriman: pengiriman);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (dapurPengirimanController.sekolahId == null) {
            MBGLoaders.errorSnackBar(
              title: 'Sekolah belum tersedia',
              message:
                  'Tidak ada sekolah yang dilayani untuk membuat pengiriman.',
            );
            return;
          }
          Get.to(() => const DapurPengirimanAdd());
        },
        backgroundColor: MBGColors.primary,
        icon: Icon(Iconsax.profile_add, color: MBGColors.white),
        label: Text(
          'Buat Pengiriman',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: MBGColors.white),
        ),
      ),
    );
  }
}
