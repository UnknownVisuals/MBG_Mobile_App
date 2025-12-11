import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/empty_list_display.dart';
import 'package:mbg_mobile_app/common/widgets/chip_filter.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_tray_return_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_tray_return/widgets/sekolah_tray_return_card.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_tray_return/widgets/sekolah_tray_return_add.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahTrayReturnScreen extends StatelessWidget {
  const SekolahTrayReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SekolahTrayReturnController());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.resetForm();
          controller.fetchCompletedPengiriman();
          Get.to(() => const SekolahTrayReturnAdd());
        },
        backgroundColor: MBGColors.primary,
        icon: const Icon(Iconsax.add, color: MBGColors.white),
        label: const Text(
          'Buat Pengembalian',
          style: TextStyle(color: MBGColors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.trayReturns.isEmpty) {
          return const MBGEmptyListDisplay(
            title: 'Belum ada data',
            subTitle: 'Daftar pengembalian tray akan muncul di sini',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchTrayReturns,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(MBGSizes.md),
                child: Row(
                  children: [
                    MBChipFilter(
                      chipFilterString: 'Semua (${controller.totalCount})',
                      chipFilterIcon: Iconsax.category,
                      chipFilterColor: MBGColors.darkGrey,
                      isSelected: controller.selectedFilter.value == 'all',
                      onTap: () => controller.setFilter('all'),
                    ),
                    const SizedBox(width: MBGSizes.spaceBtwItems),
                    MBChipFilter(
                      chipFilterString:
                          'Menunggu Pickup (${controller.menungguPickupCount})',
                      chipFilterIcon: Iconsax.clock,
                      chipFilterColor: MBGColors.warning,
                      isSelected:
                          controller.selectedFilter.value == 'MENUNGGU_PICKUP',
                      onTap: () => controller.setFilter('MENUNGGU_PICKUP'),
                    ),
                    const SizedBox(width: MBGSizes.spaceBtwItems),
                    MBChipFilter(
                      chipFilterString:
                          'Sedang Dikirim (${controller.sedangReturnCount})',
                      chipFilterIcon: Iconsax.truck,
                      chipFilterColor: MBGColors.info,
                      isSelected:
                          controller.selectedFilter.value == 'SEDANG_RETURN',
                      onTap: () => controller.setFilter('SEDANG_RETURN'),
                    ),
                    const SizedBox(width: MBGSizes.spaceBtwItems),
                    MBChipFilter(
                      chipFilterString:
                          'Selesai (${controller.sampaiDapurCount})',
                      chipFilterIcon: Iconsax.tick_circle,
                      chipFilterColor: MBGColors.success,
                      isSelected:
                          controller.selectedFilter.value == 'SAMPAI_DAPUR',
                      onTap: () => controller.setFilter('SAMPAI_DAPUR'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    MBGSizes.md,
                    0,
                    MBGSizes.md,
                    MBGSizes.md,
                  ),
                  itemCount: controller.filteredTrayReturns.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: MBGSizes.spaceBtwItems),
                  itemBuilder: (context, index) {
                    final item = controller.filteredTrayReturns[index];
                    return SekolahTrayReturnCard(item: item);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
