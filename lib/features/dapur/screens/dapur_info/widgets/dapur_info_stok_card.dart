import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurInfoStokCard extends StatelessWidget {
  const DapurInfoStokCard({super.key, required this.stok});

  final StockSummary stok;

  IconData _getCategoryIcon() {
    switch (stok.kategori!.toUpperCase()) {
      case 'SAYURAN':
        return Iconsax.tree;
      case 'PROTEIN':
        return Iconsax.health;
      case 'KARBOHIDRAT':
        return Iconsax.menu_board;
      case 'BUMBU':
        return Iconsax.magic_star;
      default:
        return Iconsax.box;
    }
  }

  Color _getStockLevelColor() {
    if (stok.stokKg! < 5) {
      return Colors.red.shade400;
    } else if (stok.stokKg! < 20) {
      return Colors.orange.shade400;
    } else {
      return Colors.green.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);
    final stockColor = _getStockLevelColor();

    return Container(
      width: 240,
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        color: isDarkMode ? MBGColors.dark : MBGColors.light,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        border: Border.all(
          color: isDarkMode
              ? MBGColors.lightGrey.withValues(alpha: 0.4)
              : MBGColors.grey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(MBGSizes.sm + 2),
                decoration: BoxDecoration(
                  color: stockColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  color: stockColor,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  stok.nama ?? '-',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDarkMode
                        ? MBGColors.textWhite
                        : MBGColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Divider(
            color: isDarkMode
                ? MBGColors.lightGrey.withValues(alpha: 0.2)
                : MBGColors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              Icon(
                Iconsax.category,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  stok.kategori!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? MBGColors.textWhite
                        : MBGColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.sm,
              vertical: MBGSizes.xs,
            ),
            decoration: BoxDecoration(
              color: stockColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
              border: Border.all(color: stockColor, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.weight_1, color: stockColor, size: 14),
                const SizedBox(width: MBGSizes.xs),
                Text(
                  '${stok.stokKg!.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: stockColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
