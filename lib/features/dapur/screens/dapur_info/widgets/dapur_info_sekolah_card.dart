import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoSekolahCard extends StatelessWidget {
  const DapurInfoSekolahCard({super.key, required this.sekolahDilayani});

  final SekolahDilayaniSummary sekolahDilayani;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC94D6E), Color(0xFFD4A92E)],
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
                padding: const EdgeInsets.all(MBGSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: const Icon(
                  Iconsax.building_4,
                  color: MBGColors.white,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  sekolahDilayani.sekolah.nama,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MBGColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          const Divider(color: MBGColors.grey),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Iconsax.location,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  sekolahDilayani.sekolah.alamat,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: MBGColors.textWhite),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              const Icon(
                Iconsax.location_tick,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  '${sekolahDilayani.sekolah.latitude.toStringAsFixed(4)}, ${sekolahDilayani.sekolah.longitude.toStringAsFixed(4)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: MBGColors.textWhite),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.calendar, color: MBGColors.white, size: 12),
                const SizedBox(width: MBGSizes.xs),
                Text(
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(sekolahDilayani.createdAt.toLocal()),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MBGColors.textWhite,
                    fontWeight: FontWeight.w500,
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
