import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

/// Widget untuk menampilkan menu hari ini (UI Only)
class SekolahDashboardTodayMenu extends StatelessWidget {
  const SekolahDashboardTodayMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SekolahDashboardController>();
    final dark = MBGHelperFunctions.isDarkMode(context);

    return Obx(() {
      final menu = controller.todayMenuHarian.value;

      if (menu == null) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(MBGSizes.md),
          decoration: BoxDecoration(
            color: dark ? MBGColors.dark : MBGColors.white,
            borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            border: Border.all(
              color: dark ? MBGColors.darkerGrey : MBGColors.grey,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Iconsax.calendar_remove,
                size: 32,
                color: dark ? MBGColors.darkGrey : MBGColors.darkGrey,
              ),
              const SizedBox(height: MBGSizes.sm),
              Text(
                'Tidak ada menu hari ini',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dark ? MBGColors.darkGrey : MBGColors.darkGrey,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(MBGSizes.md),
        decoration: BoxDecoration(
          color: dark ? MBGColors.dark : MBGColors.white,
          borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
          border: Border.all(
            color: dark ? MBGColors.darkerGrey : MBGColors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(MBGSizes.sm),
                  decoration: BoxDecoration(
                    color: MBGColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                  ),
                  child: const Icon(
                    Iconsax.reserve,
                    size: 24,
                    color: MBGColors.primary,
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.namaMenu ?? 'Menu Tanpa Nama',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: dark
                                  ? MBGColors.white
                                  : MBGColors.textPrimary,
                            ),
                      ),
                      if (menu.kalori != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${menu.kalori?.toStringAsFixed(0)} kkal',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: dark
                                    ? MBGColors.textSecondary
                                    : MBGColors.textSecondary,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (menu.protein != null ||
                menu.karbohidrat != null ||
                menu.lemak != null) ...[
              const SizedBox(height: MBGSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: MBGSizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNutrientInfo(
                    context,
                    'Protein',
                    '${menu.protein?.toStringAsFixed(1)}g',
                    Iconsax.weight,
                    dark,
                  ),
                  _buildNutrientInfo(
                    context,
                    'Karbo',
                    '${menu.karbohidrat?.toStringAsFixed(1)}g',
                    Iconsax.flash_1,
                    dark,
                  ),
                  _buildNutrientInfo(
                    context,
                    'Lemak',
                    '${menu.lemak?.toStringAsFixed(1)}g',
                    Iconsax.drop,
                    dark,
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildNutrientInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool dark,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: MBGColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: MBGColors.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: dark ? MBGColors.textSecondary : MBGColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
