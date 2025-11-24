import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahKelasCard extends StatelessWidget {
  const SekolahKelasCard({
    super.key,
    required this.kelas,
    required this.onEdit,
    required this.onDelete,
  });

  final SekolahKelasModel kelas;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get _formattedDate {
    if (kelas.createdAt == null) return '-';
    return DateFormat('dd MMM yyyy').format(kelas.createdAt!.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF2A7ABD), Color(0xFF00A8B3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final studentCount = kelas.count?.siswa ?? kelas.jumlahSiswa ?? 0;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(MBGSizes.sm),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(
                        MBGSizes.borderRadiusMd,
                      ),
                    ),
                    child: const Icon(
                      Iconsax.buildings,
                      color: MBGColors.white,
                      size: MBGSizes.iconMd,
                    ),
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                  Text(
                    kelas.nama ?? 'Kelas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: MBGColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.edit, color: MBGColors.white),
                    onPressed: onEdit,
                    tooltip: 'Edit Kelas',
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.trash, color: MBGColors.white),
                    onPressed: onDelete,
                    tooltip: 'Hapus Kelas',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          const Divider(color: Colors.white70),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Row(
            children: [
              const Icon(Iconsax.briefcase, color: MBGColors.white, size: 16),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Text(
                'Tingkat ${kelas.tingkat ?? '-'}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MBGColors.textWhite),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              const Icon(Iconsax.user, color: MBGColors.white, size: 16),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Text(
                '$studentCount siswa',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: MBGColors.textWhite,
                  fontWeight: FontWeight.bold,
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
            ),
            child: Text(
              'Dibuat: $_formattedDate',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: MBGColors.textWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
