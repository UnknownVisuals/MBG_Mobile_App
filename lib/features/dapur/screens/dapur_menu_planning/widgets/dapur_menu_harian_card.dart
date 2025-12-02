// lib/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_checkpoint_status.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_time_range.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_nutricion_info.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurMenuHarianCard extends StatelessWidget {
  const DapurMenuHarianCard({super.key, required this.menuHarian});

  final DapurMenuHarianModel menuHarian;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final costLabel =
        '${currencyFormatter.format(menuHarian.biayaPerTray)}/tray';
    final formattedDate = DateFormat(
      'EEEE, dd MMM yyyy',
      'id_ID',
    ).format(menuHarian.tanggal!.toLocal());

    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        color: isDarkMode ? MBGColors.dark : MBGColors.light,
        border: Border.all(
          color: isDarkMode
              ? MBGColors.lightGrey.withValues(alpha: 0.4)
              : MBGColors.grey,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            menuHarian.namaMenu!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          // Date row
          Row(
            children: [
              Icon(
                Iconsax.calendar,
                size: MBGSizes.iconSm,
                color: isDarkMode ? MBGColors.lightGrey : MBGColors.darkGrey,
              ),
              const SizedBox(width: MBGSizes.xs),
              Text(
                formattedDate,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          // Cost & Tray
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: MBGSizes.md,
                  vertical: MBGSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: MBGColors.success.withValues(alpha: 0.2),
                  border: Border.all(
                    color: MBGColors.success.withValues(alpha: 0.4),
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

              const SizedBox(width: MBGSizes.sm),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: MBGSizes.md,
                  vertical: MBGSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: MBGColors.primary.withValues(alpha: 0.2),
                  border: Border.all(
                    color: MBGColors.primary.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.box,
                      size: MBGSizes.iconSm,
                      color: MBGColors.primary,
                    ),
                    const SizedBox(width: MBGSizes.xs),
                    Text(
                      '${menuHarian.targetTray} Tray',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MBGColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Divider(
            color: isDarkMode
                ? MBGColors.lightGrey.withValues(alpha: 0.3)
                : MBGColors.grey,
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),

          // Time ranges
          Row(
            children: [
              Expanded(
                child: DapurMenuHarianTimeRange(
                  icon: Iconsax.timer_start,
                  label: 'Start',
                  value: menuHarian.jamMulaiMasak!,
                  color: MBGColors.primary,
                ),
              ),
              const SizedBox(width: MBGSizes.sm),
              Expanded(
                child: DapurMenuHarianTimeRange(
                  icon: Iconsax.timer_pause,
                  label: 'End',
                  value: menuHarian.jamSelesaiMasak!,
                  color: MBGColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          // Nutrition
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DapurMenuHarianNutricionInfo(
                label: 'Kalori',
                value: menuHarian.kalori!,
                unit: 'kcal',
                icon: Icons.local_fire_department,
              ),
              DapurMenuHarianNutricionInfo(
                label: 'Protein',
                value: menuHarian.protein!,
                unit: 'g',
                icon: Icons.egg,
              ),
              DapurMenuHarianNutricionInfo(
                label: 'Karbo',
                value: menuHarian.karbohidrat!,
                unit: 'g',
                icon: Icons.grain,
              ),
              DapurMenuHarianNutricionInfo(
                label: 'Lemak',
                value: menuHarian.lemak!,
                unit: 'g',
                icon: Icons.water_drop,
              ),
            ],
          ),

          // Checkpoint
          DapurMenuHarianCheckpointStatus(checkpoints: menuHarian.checkpoint!),
        ],
      ),
    );
  }
}
