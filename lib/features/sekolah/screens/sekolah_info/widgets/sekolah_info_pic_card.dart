import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class SekolahInfoPicCard extends StatelessWidget {
  const SekolahInfoPicCard({super.key, required this.pic});

  final SekolahInfoPICSekolahSummary pic;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);
    const accentColor = Color(0xFF5A3680);

    return Container(
      width: 280,
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
                  Iconsax.profile_circle5,
                  color: accentColor,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  pic.name ?? 'PIC Sekolah',
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
                Iconsax.direct_right,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  pic.email ?? '-',
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
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              Icon(
                Iconsax.call,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Text(
                pic.phone ?? '-',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? MBGColors.textWhite
                      : MBGColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
