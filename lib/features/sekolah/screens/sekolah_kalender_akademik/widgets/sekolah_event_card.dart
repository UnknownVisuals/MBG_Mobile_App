import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kalender_akademik_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kalender_akademik_model.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kalender_akademik/widgets/sekolah_kalender_akademik_delete.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kalender_akademik/widgets/sekolah_kalender_akademik_edit.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class SekolahEventCard extends StatelessWidget {
  const SekolahEventCard({super.key, required this.event});

  final SekolahKalenderAkademikModel event;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SekolahKalenderAkademikController>();
    final dark = MBGHelperFunctions.isDarkMode(context);
    final startDate = event.tanggalMulai;
    final endDate = event.tanggalSelesai;

    String dateString;
    if (startDate != null && endDate != null && startDate != endDate) {
      dateString =
          '${DateFormat('dd MMM yyyy', 'id_ID').format(startDate)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(endDate)}';
    } else if (startDate != null) {
      dateString = DateFormat('dd MMMM yyyy', 'id_ID').format(startDate);
    } else {
      dateString = '-';
    }

    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: dark ? MBGColors.dark : MBGColors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        border: Border.all(color: dark ? MBGColors.darkerGrey : MBGColors.grey),
        boxShadow: [
          if (!dark)
            BoxShadow(
              color: MBGColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(MBGSizes.sm),
            decoration: BoxDecoration(
              color: MBGColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusSm),
            ),
            child: const Icon(
              Iconsax.calendar_1,
              color: MBGColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: MBGSizes.spaceBtwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.deskripsi ?? 'Tidak ada deskripsi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? MBGColors.white : MBGColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: MBGSizes.xs),
                Text(
                  dateString,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: dark ? MBGColors.grey : MBGColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () =>
                    Get.to(() => SekolahKalenderAkademikEdit(event: event)),
                icon: const Icon(Iconsax.edit, color: MBGColors.primary),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: () async {
                  final confirmed = await Get.dialog<bool>(
                    SekolahKalenderAkademikDelete(event: event),
                  );
                  if (confirmed == true) {
                    controller.deleteEvent(event.id);
                  }
                },
                icon: const Icon(Iconsax.trash, color: MBGColors.error),
                tooltip: 'Hapus',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
