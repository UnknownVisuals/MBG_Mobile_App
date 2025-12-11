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

class DapurPengirimanScreen extends StatelessWidget {
  const DapurPengirimanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DapurPengirimanController());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? MBGColors.black : MBGColors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: MBGSpacingStyles.homeScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===============================
                  ///          DROPDOWN SEKOLAH
                  /// ===============================
                  Obx(() {
                    if (controller.isLoading.value &&
                        controller.sekolahList.isEmpty) {
                      return const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    if (controller.sekolahList.isEmpty) {
                      return Text(
                        'Belum ada sekolah yang dilayani',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    }

                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Sekolah',
                        prefixIcon: const Icon(Iconsax.building_3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                      child: Text(
                        controller.sekolahNama ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }),

                  const SizedBox(height: MBGSizes.spaceBtwItems),

                  /// ===============================
                  ///            CHIP FILTER
                  /// ===============================
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          MBChipFilter(
                            chipFilterString:
                                'Semua (${controller.totalCount})',
                            chipFilterColor: MBGColors.darkGrey,
                            chipFilterIcon: Iconsax.category,
                            isSelected:
                                controller.selectedFilter.value == 'all',
                            onTap: () => controller.setFilter('all'),
                          ),
                          const SizedBox(width: MBGSizes.spaceBtwItems),
                          MBChipFilter(
                            chipFilterString:
                                'Pending (${controller.pendingCount})',
                            chipFilterColor: MBGColors.warning,
                            chipFilterIcon: Iconsax.clock,
                            isSelected:
                                controller.selectedFilter.value == 'pending',
                            onTap: () => controller.setFilter('pending'),
                          ),
                          const SizedBox(width: MBGSizes.spaceBtwItems),
                          MBChipFilter(
                            chipFilterString:
                                'Dikirim (${controller.inTransitCount})',
                            chipFilterColor: MBGColors.info,
                            chipFilterIcon: Iconsax.truck_fast,
                            isSelected:
                                controller.selectedFilter.value == 'in_transit',
                            onTap: () => controller.setFilter('in_transit'),
                          ),
                          const SizedBox(width: MBGSizes.spaceBtwItems),
                          MBChipFilter(
                            chipFilterString:
                                'Selesai (${controller.completedCount})',
                            chipFilterColor: MBGColors.success,
                            chipFilterIcon: Iconsax.tick_circle,
                            isSelected:
                                controller.selectedFilter.value == 'completed',
                            onTap: () => controller.setFilter('completed'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: MBGSizes.spaceBtwItems),

                  /// ===============================
                  ///        LIST PENGIRIMAN
                  /// ===============================
                  Expanded(
                    child: RefreshIndicator(
                      color: MBGColors.primary,
                      onRefresh: controller.refreshPengiriman,
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: MBGColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        final list = controller.filteredPengiriman;

                        if (list.isEmpty) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: const DapurPengirimanEmpty(),
                                ),
                              );
                            },
                          );
                        }

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: list.length,
                          itemBuilder: (context, i) =>
                              DapurPengirimanCard(pengiriman: list[i]),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      /// ===============================
      ///         TOMBOL FAB
      /// ===============================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (controller.sekolahId == null) {
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
