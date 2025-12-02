import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class SekolahInfoKelasCard extends StatelessWidget {
  const SekolahInfoKelasCard({super.key, required this.kelas});

  final SekolahInfoKelasSummary kelas;

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy', 'id_ID').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final studentCount = kelas.count?.siswa;
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);
    const accentColor = Color(0xFF2A7ABD);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(MBGSizes.sm + 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: const Icon(
                  Iconsax.buildings,
                  color: accentColor,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  kelas.nama ?? 'Kelas',
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
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Divider(
            color: isDarkMode
                ? MBGColors.lightGrey.withValues(alpha: 0.2)
                : MBGColors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              Icon(
                Iconsax.briefcase,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  'Tingkat ${kelas.tingkat?.toString() ?? '-'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? MBGColors.textWhite
                        : MBGColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.user,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Text(
                '${studentCount ?? 0} siswa',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? MBGColors.textWhite
                      : MBGColors.textPrimary,
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
              color: isDarkMode
                  ? MBGColors.darkerGrey
                  : MBGColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
            ),
            child: Text(
              'Dibuat: ${_formatDate(kelas.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
