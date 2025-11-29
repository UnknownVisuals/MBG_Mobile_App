import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoDriverCard extends StatelessWidget {
  const DapurInfoDriverCard({super.key, required this.driver});

  final DriversSummary driver;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260, // dikurangi agar tidak overflow di list
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB86DB8), Color(0xFFC73D51)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
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
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Iconsax.truck_fast,
                  color: MBGColors.white,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.sm),

              Expanded(
                child: Text(
                  driver.name!,
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

          const SizedBox(height: MBGSizes.xs),
          Divider(color: MBGColors.white.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: MBGSizes.xs),

          /// ==== EMAIL ====
          Row(
            children: [
              const Icon(
                Iconsax.direct_right,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.xs),

              Expanded(
                child: Text(
                  driver.email!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: MBGColors.textWhite),
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
              const Icon(
                Iconsax.call,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.xs),

              Expanded(
                child: Text(
                  driver.phone!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: MBGColors.textWhite),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.car, color: MBGColors.white, size: 16),
                const SizedBox(width: MBGSizes.xs),

                Expanded(
                  child: Text(
                    driver.nomorKendaraan!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MBGColors.textWhite,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
