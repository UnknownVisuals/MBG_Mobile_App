import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:mbg_mobile_app/common/widgets/chip_filter.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import '../../../controllers/dapur_stock_controller.dart';
import '../../../models/dapur_stok_model.dart';
import 'dapur_stock_delete.dart';
import 'dapur_stock_edit.dart';

/// Stok content widget with category filters and list presentation.
class DapurStockCard extends StatelessWidget {
  const DapurStockCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurStockController stokController =
        Get.find<DapurStockController>();

    return Obx(() {
      final categories = stokController.kategoriOptions;
      final selectedCategory = stokController.selectedCategory.value;
      final filteredStokList = stokController.filteredStokList;
      final isLoading = stokController.isLoading.value;
      final deletingStockId = stokController.deletingStockId.value;

      final textTheme = Theme.of(context).textTheme;

      final filterOptions = <_FilterOption>[
        const _FilterOption(
          kategori: null,
          label: 'Semua',
          color: MBGColors.primary,
          icon: Iconsax.hierarchy,
        ),
        ...categories.map(
          (kategori) => _FilterOption(
            kategori: kategori,
            label: kategori.label,
            color: _getCategoryColor(kategori),
            icon: _getCategoryIcon(kategori),
          ),
        ),
      ];

      return Column(
        children: [
          SizedBox(
            height: MBGSizes.imageThumbSize,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: MBGSizes.md,
                vertical: MBGSizes.sm,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: filterOptions.length,
              separatorBuilder: (context, _) =>
                  const SizedBox(width: MBGSizes.sm),
              itemBuilder: (context, index) {
                final option = filterOptions[index];
                final isSelected = option.kategori == null
                    ? selectedCategory == null
                    : selectedCategory == option.kategori;

                return MBChipFilter(
                  chipFilterString: option.label,
                  chipFilterColor: option.color,
                  chipFilterIcon: option.icon,
                  isSelected: isSelected,
                  onTap: () => stokController.selectCategory(option.kategori),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredStokList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.box,
                          size: MBGSizes.imageThumbSize,
                          color: MBGColors.grey,
                        ),
                        const SizedBox(height: MBGSizes.spaceBtwItems),
                        Text(
                          'Belum ada stok',
                          style: textTheme.titleMedium?.copyWith(
                            color: MBGColors.darkGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: MBGSizes.sm),
                        Text(
                          'Tambahkan stok dengan tombol + di bawah',
                          style: textTheme.bodyMedium?.copyWith(
                            color: MBGColors.darkGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => stokController.fetchStok(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(MBGSizes.md),
                      itemCount: filteredStokList.length,
                      itemBuilder: (context, index) {
                        final stok = filteredStokList[index];
                        final categoryColor = _getCategoryColor(stok.kategori);
                        final categoryIcon = _getCategoryIcon(stok.kategori);
                        final isLowStock = stok.stokKg < 5;

                        return Card(
                          elevation: MBGSizes.cardElevation,
                          margin: const EdgeInsets.only(
                            bottom: MBGSizes.spaceBtwItems,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              MBGSizes.borderRadiusLg,
                            ),
                            side: isLowStock
                                ? const BorderSide(
                                    color: MBGColors.error,
                                    width: 2,
                                  )
                                : BorderSide.none,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(MBGSizes.md),
                            leading: CircleAvatar(
                              backgroundColor: categoryColor.withValues(
                                alpha: 0.2,
                              ),
                              child: Icon(
                                categoryIcon,
                                color: categoryColor,
                                size: MBGSizes.iconMd,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    stok.nama,
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isLowStock)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: MBGSizes.sm,
                                      vertical: MBGSizes.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MBGColors.error,
                                      borderRadius: BorderRadius.circular(
                                        MBGSizes.borderRadiusSm,
                                      ),
                                    ),
                                    child: Text(
                                      'STOK RENDAH',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: MBGColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: MBGSizes.sm),
                                Text(
                                  stok.kategoriLabel,
                                  style: textTheme.labelLarge?.copyWith(
                                    color: categoryColor,
                                  ),
                                ),
                                const SizedBox(height: MBGSizes.xs),
                                Text(
                                  'Stok: ${stok.stokKg} kg',
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isLowStock
                                        ? MBGColors.error
                                        : MBGColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Iconsax.edit),
                                  color: MBGColors.primary,
                                  onPressed: () => _openEditForm(stok),
                                ),
                                IconButton(
                                  icon: deletingStockId == stok.id
                                      ? const SizedBox(
                                          width:
                                              MBGSizes.loadingIndicatorSize / 2,
                                          height:
                                              MBGSizes.loadingIndicatorSize / 2,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Iconsax.trash),
                                  color: MBGColors.error,
                                  onPressed: deletingStockId == stok.id
                                      ? null
                                      : () => _confirmDelete(
                                          context: context,
                                          controller: stokController,
                                          stok: stok,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      );
    });
  }

  Future<void> _confirmDelete({
    required BuildContext context,
    required DapurStockController controller,
    required StokModel stok,
  }) async {
    final confirm = await Get.dialog<bool>(
      DapurStockDeleteDialog(stok: stok),
      barrierDismissible: false,
    );

    if (confirm == true) {
      await controller.deleteStok(stok.id);
    }
  }

  void _openEditForm(StokModel stok) {
    Get.to(() => DapurStockEdit(stok: stok));
  }

  Color _getCategoryColor(KategoriStok kategori) {
    switch (kategori) {
      case KategoriStok.SAYURAN:
        return MBGColors.success;
      case KategoriStok.BUMBU:
        return MBGColors.warning;
      case KategoriStok.PROTEIN:
        return MBGColors.error;
      case KategoriStok.KARBOHIDRAT:
        return MBGColors.info;
      case KategoriStok.LAINNYA:
        return MBGColors.darkGrey;
    }
  }

  IconData _getCategoryIcon(KategoriStok kategori) {
    switch (kategori) {
      case KategoriStok.SAYURAN:
        return Iconsax.shopping_bag;
      case KategoriStok.BUMBU:
        return Iconsax.tag;
      case KategoriStok.PROTEIN:
        return Iconsax.activity;
      case KategoriStok.KARBOHIDRAT:
        return Iconsax.box;
      case KategoriStok.LAINNYA:
        return Iconsax.category;
    }
  }
}

class _FilterOption {
  const _FilterOption({
    required this.label,
    required this.color,
    required this.icon,
    this.kategori,
  });

  final String label;
  final Color color;
  final IconData icon;
  final KategoriStok? kategori;
}
