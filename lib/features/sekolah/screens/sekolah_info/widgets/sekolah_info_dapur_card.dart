import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class SekolahInfoDapurCard extends StatelessWidget {
  const SekolahInfoDapurCard({super.key, required this.pelayanan});

  final SekolahInfoDapurPelayananSummary pelayanan;

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy', 'id_ID').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final dapur = pelayanan.dapur;
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);
    const accentColor = Color(0xFFC94D6E);

    return Container(
      width: 300,
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
                  Iconsax.clipboard_text,
                  color: accentColor,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  dapur?.nama ?? 'Dapur Pelayanan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDarkMode
                        ? MBGColors.textWhite
                        : MBGColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Iconsax.location,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  dapur?.alamat ?? '-',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode
                        ? MBGColors.textWhite
                        : MBGColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              Icon(
                Iconsax.location_tick,
                color: isDarkMode ? MBGColors.textWhite : MBGColors.textPrimary,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  dapur != null &&
                          dapur.latitude != null &&
                          dapur.longitude != null
                      ? '${dapur.latitude!.toStringAsFixed(4)}, ${dapur.longitude!.toStringAsFixed(4)}'
                      : '-',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.calendar,
                  color: isDarkMode
                      ? MBGColors.textWhite
                      : MBGColors.textPrimary,
                  size: 12,
                ),
                const SizedBox(width: MBGSizes.xs),
                Text(
                  'Bergabung: ${_formatDate(pelayanan.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode
                        ? MBGColors.textWhite
                        : MBGColors.textPrimary,
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
