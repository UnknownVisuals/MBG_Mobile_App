import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kalender_akademik_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahEventCard extends StatelessWidget {
  const SekolahEventCard({super.key, required this.event});

  final SekolahKalenderAkademikModel event;

  String _buildDateLabel() {
    final start = event.tanggalMulai;
    final end = event.tanggalSelesai;
    if (start == null) return 'Tanggal tidak tersedia';
    final formatter = DateFormat('dd MMM yyyy');
    if (end != null && !_isSameDay(start, end)) {
      return '${formatter.format(start)} • ${formatter.format(end)}';
    }
    return formatter.format(start);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final description = event.deskripsi?.trim();
    final title = description?.isNotEmpty == true
        ? description
        : 'Kalender Akademik';
    final dateLabel = _buildDateLabel();
    final sekolahBadge = event.sekolahId.length > 5
        ? event.sekolahId.substring(0, 5)
        : event.sekolahId;
    final eventIdentifier = event.id.length > 6
        ? event.id.substring(0, 6)
        : event.id;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MBGColors.primary, MBGColors.primary.withValues(alpha: 0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: MBGColors.dark.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconCircle(),
                const SizedBox(width: MBGSizes.sm),
                Expanded(child: _buildTitle(context, title!, sekolahBadge)),
              ],
            ),
            const SizedBox(height: MBGSizes.sm),
            _buildInfoRow(icon: Iconsax.calendar_circle, label: dateLabel),
            const SizedBox(height: MBGSizes.xs),
            _buildInfoRow(
              icon: Iconsax.tag_2,
              label: 'Event ID: $eventIdentifier',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle() {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.xs),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MBGColors.primary.withValues(alpha: 0.15),
      ),
      child: Icon(
        Iconsax.calendar_tick,
        color: MBGColors.primary,
        size: MBGSizes.iconMd,
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title, String badge) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: MBGSizes.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: MBGSizes.xs,
            horizontal: MBGSizes.sm,
          ),
          decoration: BoxDecoration(
            color: MBGColors.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(MBGSizes.cardRadiusSm),
          ),
          child: Text(
            badge,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: MBGColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: MBGSizes.iconSm, color: MBGColors.textSecondary),
        const SizedBox(width: MBGSizes.xs),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: MBGColors.textSecondary,
              fontSize: MBGSizes.sm,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
