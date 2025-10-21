import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import 'menu_planning_info_chip_widget.dart';
import 'menu_planning_nutrition_info_widget.dart';

/// Card widget displaying daily menu details
class MenuHarianCardWidget extends StatelessWidget {
  final dynamic menu;

  const MenuHarianCardWidget({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: MBGSizes.md),
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.namaMenu,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: MBGSizes.xs),
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: MBGSizes.xs),
                          Text(
                            DateFormat(
                              'EEEE, dd MMM yyyy',
                            ).format(menu.tanggal),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MBGSizes.md,
                    vertical: MBGSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: MBGColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                  ),
                  child: Text(
                    'Rp ${menu.biayaPerTray.toStringAsFixed(0)}/tray',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MBGColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: MBGSizes.spaceBtwItems),

            // Cooking Times
            Row(
              children: [
                Expanded(
                  child: MenuPlanningInfoChipWidget(
                    icon: Iconsax.timer_start,
                    label: 'Start',
                    value: menu.jamMulaiMasak,
                    color: MBGColors.primary,
                  ),
                ),
                const SizedBox(width: MBGSizes.sm),
                Expanded(
                  child: MenuPlanningInfoChipWidget(
                    icon: Iconsax.timer_pause,
                    label: 'End',
                    value: menu.jamSelesaiMasak,
                    color: MBGColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.sm),

            // Nutrition Info
            Container(
              padding: const EdgeInsets.all(MBGSizes.sm),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MenuPlanningNutritionInfoWidget(
                    label: 'Kalori',
                    value: menu.kalori,
                    unit: 'kcal',
                    icon: Icons.local_fire_department,
                  ),
                  MenuPlanningNutritionInfoWidget(
                    label: 'Protein',
                    value: menu.protein,
                    unit: 'g',
                    icon: Icons.egg,
                  ),
                  MenuPlanningNutritionInfoWidget(
                    label: 'Karbo',
                    value: menu.karbohidrat,
                    unit: 'g',
                    icon: Icons.grain,
                  ),
                  MenuPlanningNutritionInfoWidget(
                    label: 'Lemak',
                    value: menu.lemak,
                    unit: 'g',
                    icon: Icons.water_drop,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
