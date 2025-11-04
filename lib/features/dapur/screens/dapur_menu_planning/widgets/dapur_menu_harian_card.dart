import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_time_range.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_nutricion_info.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Simple data holder for presenting a daily menu card.
class MenuHarianCardData {
  final String title;
  final DateTime date;
  final int costPerTray;
  final String startTime;
  final String endTime;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const MenuHarianCardData({
    required this.title,
    required this.date,
    required this.costPerTray,
    required this.startTime,
    required this.endTime,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  String get formattedDate => DateFormat('EEEE, dd MMM yyyy').format(date);
}

/// Card widget displaying daily menu details
class DapurMenuHarianCard extends StatelessWidget {
  const DapurMenuHarianCard({super.key, required this.data});

  final MenuHarianCardData data;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final costLabel = '${currencyFormatter.format(data.costPerTray)}/tray';

    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        color: MBGColors.light,
        border: Border.all(color: MBGColors.borderPrimary),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Date Row
          Text(
            'Sate Ayam + Nasi Uduk + Lalapan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              Icon(
                Iconsax.calendar,
                size: MBGSizes.iconSm,
                color: MBGColors.textSecondary,
              ),
              const SizedBox(width: MBGSizes.xs),
              Text(
                data.formattedDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: MBGSizes.md,
                  vertical: MBGSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: MBGColors.success.withValues(alpha: 0.1),
                  border: Border.all(
                    color: MBGColors.success.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: Text(
                  costLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MBGColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                tooltip: 'Edit',
                icon: const Icon(Iconsax.edit_2, color: MBGColors.primary),
              ),
              IconButton(
                onPressed: () {},
                tooltip: 'Delete',
                icon: const Icon(Iconsax.trash, color: MBGColors.error),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          const Divider(),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),

          // Cooking Times
          Row(
            children: [
              Expanded(
                child: DapurMenuHarianTimeRange(
                  icon: Iconsax.timer_start,
                  label: 'Start',
                  value: data.startTime,
                  color: MBGColors.primary,
                ),
              ),
              const SizedBox(width: MBGSizes.sm),
              Expanded(
                child: DapurMenuHarianTimeRange(
                  icon: Iconsax.timer_pause,
                  label: 'End',
                  value: data.endTime,
                  color: MBGColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          // Nutrition Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DapurMenuHarianNutricionInfo(
                label: 'Kalori',
                value: data.calories,
                unit: 'kcal',
                icon: Icons.local_fire_department,
              ),
              DapurMenuHarianNutricionInfo(
                label: 'Protein',
                value: data.protein,
                unit: 'g',
                icon: Icons.egg,
              ),
              DapurMenuHarianNutricionInfo(
                label: 'Karbo',
                value: data.carbs,
                unit: 'g',
                icon: Icons.grain,
              ),
              DapurMenuHarianNutricionInfo(
                label: 'Lemak',
                value: data.fat,
                unit: 'g',
                icon: Icons.water_drop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
