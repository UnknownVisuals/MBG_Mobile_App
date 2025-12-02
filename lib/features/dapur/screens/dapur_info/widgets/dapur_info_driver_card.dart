import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurInfoDriverCard extends StatelessWidget {
  const DapurInfoDriverCard({super.key, required this.driver});

  final DriversSummary driver;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);
    const accentColor = Color(0xFFC73D51); // Keeping the red/pink accent

    return Container(
      width: 260, // dikurangi agar tidak overflow di list
      padding: const EdgeInsets.all(MBGSizes.md),
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
        mainAxisSize: MainAxisSize.min, // ⛔ mencegah tinggi membengkak
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ==== HEADER DRIVER ====
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(MBGSizes.sm),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: const Icon(
                  Iconsax.truck_fast,
                  color: accentColor,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.sm),

              Expanded(
                child: Text(
                  driver.name!,
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

          const SizedBox(height: MBGSizes.xs),
          Divider(
            color: isDarkMode
                ? MBGColors.lightGrey.withValues(alpha: 0.2)
                : MBGColors.grey.withValues(alpha: 0.5),
            height: 1,
          ),
          const SizedBox(height: MBGSizes.xs),

          /// ==== EMAIL ====
          Row(
            children: [
              Icon(
                Iconsax.direct_right,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.xs),

              Expanded(
                child: Text(
                  driver.email!,
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

          const SizedBox(height: MBGSizes.xs),

          /// ==== PHONE ====
          Row(
            children: [
              Icon(
                Iconsax.call,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.xs),

              Expanded(
                child: Text(
                  driver.phone!,
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

          const SizedBox(height: MBGSizes.xs),

          /// ==== KENDARAAN TAG ====
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.sm,
              vertical: MBGSizes.xs,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
              border: Border.all(color: accentColor, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.car, color: accentColor, size: 16),
                const SizedBox(width: MBGSizes.xs),

                Text(
                  driver.nomorKendaraan!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
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
