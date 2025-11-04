import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/chip_filter.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_stock_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stock_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'dapur_stock_delete.dart';
import 'dapur_stock_edit.dart';

class DapurStokCard extends StatelessWidget {
  const DapurStokCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurStokController dapurStokController =
        Get.find<DapurStokController>();

    final filters = [
      {
        'label': 'Semua',
        'color': MBGColors.primary,
        'icon': Iconsax.hierarchy,
        'value': null,
      },
      {
        'label': 'Sayuran',
        'color': MBGColors.success,
        'icon': Iconsax.shopping_bag,
        'value': KategoriStok.SAYURAN,
      },
      {
        'label': 'Bumbu',
        'color': MBGColors.warning,
        'icon': Iconsax.tag,
        'value': KategoriStok.BUMBU,
      },
      {
        'label': 'Protein',
        'color': MBGColors.error,
        'icon': Iconsax.activity,
        'value': KategoriStok.PROTEIN,
      },
      {
        'label': 'Karbohidrat',
        'color': MBGColors.info,
        'icon': Iconsax.box,
        'value': KategoriStok.KARBOHIDRAT,
      },
      {
        'label': 'Lainnya',
        'color': MBGColors.darkGrey,
        'icon': Iconsax.category,
        'value': KategoriStok.LAINNYA,
      },
    ];

    return Column(
      children: [
        // Filter chips
        SizedBox(
          height: MBGSizes.imageThumbSize,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.md,
              vertical: MBGSizes.sm,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (context, _) =>
                const SizedBox(width: MBGSizes.sm),
            itemBuilder: (context, index) {
              final filter = filters[index];

              return Obx(() {
                final isSelected =
                    dapurStokController.selectedCategory.value ==
                    filter['value'];

                return MBChipFilter(
                  chipFilterString: filter['label'] as String,
                  chipFilterColor: filter['color'] as Color,
                  chipFilterIcon: filter['icon'] as IconData,
                  isSelected: isSelected,
                  onTap: () => dapurStokController.selectCategory(
                    filter['value'] as KategoriStok?,
                  ),
                );
              });
            },
          ),
        ),

        // Stock list
        Expanded(
          child: Obx(() {
            if (dapurStokController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: MBGColors.primary),
              );
            }

            if (dapurStokController.filteredStokList.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => dapurStokController.refreshStok(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.box_remove,
                        size: MBGSizes.iconLg * 2,
                        color: MBGColors.darkGrey,
                      ),
                      const SizedBox(height: MBGSizes.md),
                      Text(
                        'Belum ada data stok',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: MBGColors.darkGrey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(MBGSizes.md),
              itemCount: dapurStokController.filteredStokList.length,
              itemBuilder: (context, index) {
                final stok = dapurStokController.filteredStokList[index];
                final isLowStock = stok.stokKg < 1;
                final categoryColor = dapurStokController.getCategoryColor(
                  stok.kategori,
                );
                final categoryIcon = dapurStokController.getCategoryIcon(
                  stok.kategori,
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
                  padding: const EdgeInsets.all(MBGSizes.md),
                  decoration: BoxDecoration(
                    color: MBGColors.light,
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusLg,
                    ),
                    border: Border.all(
                      color: isLowStock ? MBGColors.error : MBGColors.grey,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: categoryColor.withValues(alpha: 0.2),
                        child: Icon(
                          categoryIcon,
                          color: categoryColor,
                          size: MBGSizes.iconLg,
                        ),
                      ),
                      const SizedBox(width: MBGSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stok.nama,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (isLowStock) ...[
                              const SizedBox(height: MBGSizes.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: MBGSizes.sm,
                                  vertical: MBGSizes.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: MBGColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    MBGSizes.borderRadiusSm,
                                  ),
                                ),
                                child: Text(
                                  'Stok Menipis',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: MBGColors.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                            const SizedBox(height: MBGSizes.sm),
                            Text(
                              stok.kategoriLabel,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: categoryColor),
                            ),
                            const SizedBox(height: MBGSizes.xs),
                            Text(
                              'Stok: ${stok.stokKg.toStringAsFixed(2)} kg',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isLowStock
                                        ? MBGColors.error
                                        : MBGColors.textPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.edit),
                        color: MBGColors.primary,
                        onPressed: () =>
                            Get.to(() => DapurStokEdit(stok: stok)),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.trash),
                        color: MBGColors.error,
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                DapurStokDeleteDialog(stok: stok),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
