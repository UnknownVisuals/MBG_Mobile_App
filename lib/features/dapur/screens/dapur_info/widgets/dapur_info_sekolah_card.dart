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
      width:
          260, // ⛔ mengecil dari 300 → supaya tidak overflow saat horizontal scroll
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC94D6E), Color(0xFFD4A92E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ⛔ Hindari tinggi membengkak
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ==== NAMA SEKOLAH ====
          Row(
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
                  Iconsax.building_4,
                  color: MBGColors.white,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.sm),

              Expanded(
                child: Text(
                  sekolahDilayani.sekolah!.nama ?? '-',
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

          const SizedBox(height: MBGSizes.xs),
          Divider(color: MBGColors.white.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: MBGSizes.xs),

          /// ==== ALAMAT ====
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Iconsax.location,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.xs),

              Expanded(
                child: Text(
                  sekolahDilayani.sekolah!.alamat ?? '-',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: MBGColors.textWhite),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.xs),

          /// ==== KOORDINAT ====
          Row(
            children: [
              const Icon(
                Iconsax.location_tick,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.xs),

              Expanded(
                child: Text(
                  '${sekolahDilayani.sekolah!.latitude?.toStringAsFixed(4)}, '
                  '${sekolahDilayani.sekolah!.longitude?.toStringAsFixed(4)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: MBGColors.textWhite),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.xs),

          /// ==== TANGGAL DITAMBAHKAN ====
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.calendar, color: MBGColors.white, size: 12),
                const SizedBox(width: MBGSizes.xs),
                Text(
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(sekolahDilayani.createdAt!.toLocal()),
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
