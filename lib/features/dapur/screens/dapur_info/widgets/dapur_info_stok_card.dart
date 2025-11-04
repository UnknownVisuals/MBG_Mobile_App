import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoStokCard extends StatelessWidget {
  const DapurInfoStokCard({super.key, required this.stok});

  final StockSummary stok;

  IconData _getCategoryIcon() {
    switch (stok.kategori.toUpperCase()) {
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
    if (stok.stokKg < 5) {
      return Colors.red.shade400;
    } else if (stok.stokKg < 20) {
      return Colors.orange.shade400;
    } else {
      return Colors.green.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2BA85C), Color(0xFF27B89A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(MBGSizes.sm + 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  color: MBGColors.white,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  stok.nama,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MBGColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          const Divider(color: MBGColors.grey),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              const Icon(
                Iconsax.category,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  stok.kategori,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: MBGColors.textWhite),
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
              color: _getStockLevelColor(),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.weight_1, color: MBGColors.white, size: 14),
                const SizedBox(width: MBGSizes.xs),
                Text(
                  '${stok.stokKg.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MBGColors.textWhite,
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
