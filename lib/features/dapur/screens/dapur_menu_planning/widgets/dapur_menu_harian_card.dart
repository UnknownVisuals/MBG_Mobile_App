// lib/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_checkpoint_status.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_time_range.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_nutricion_info.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurMenuHarianCard extends StatelessWidget {
  const DapurMenuHarianCard({super.key, required this.menuHarian});

  final DapurMenuHarianModel menuHarian;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final costLabel =
        '${currencyFormatter.format(menuHarian.biayaPerTray)}/tray';
    final formattedDate = DateFormat(
      'EEEE, dd MMM yyyy',
    ).format(menuHarian.tanggal!);

    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            menuHarian.namaMenu!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          // Date row
          Row(
            children: [
              Icon(
                Iconsax.calendar,
                size: MBGSizes.iconSm,
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: MBGSizes.xs),
              Text(
                formattedDate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.7),
                ),
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
                  color: colors.secondaryContainer.withValues(alpha: 0.2),
                  border: Border.all(
                    color: colors.secondary.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: Text(
                  costLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.secondary,
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
                  color: colors.primaryContainer.withValues(alpha: 0.2),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.box,
                      size: MBGSizes.iconSm,
                      color: colors.primary,
                    ),
                    const SizedBox(width: MBGSizes.xs),
                    Text(
                      '${menuHarian.targetTray} Tray',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
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
          Divider(color: colors.outline),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),

          // Time ranges
          Row(
            children: [
              Expanded(
                child: DapurMenuHarianTimeRange(
                  icon: Iconsax.timer_start,
                  label: 'Start',
                  value: menuHarian.jamMulaiMasak!,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: MBGSizes.sm),
              Expanded(
                child: DapurMenuHarianTimeRange(
                  icon: Iconsax.timer_pause,
                  label: 'End',
                  value: menuHarian.jamSelesaiMasak!,
                  color: colors.secondary,
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
