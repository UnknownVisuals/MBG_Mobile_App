import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:ensemble_table_calendar/ensemble_table_calendar.dart';

import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kalender_akademik_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kalender_akademik_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahMainKalendar extends StatelessWidget {
  const SekolahMainKalendar({super.key, required this.controller});

  final SekolahKalenderAkademikController controller;

  List<CustomRange> _buildOverlayRanges() {
    final ranges = <CustomRange>[];
    for (final event in controller.allKalender) {
      final start = event.tanggalMulai ?? event.tanggalSelesai;
      if (start == null) continue;
      final end = event.tanggalSelesai ?? start;
      ranges.add(
        CustomRange(
          id: event.id,
          start: DateTime(start.year, start.month, start.day),
          end: DateTime(end.year, end.month, end.day),
          rowId: 1,
        ),
      );
    }
    return ranges;
  }

  bool _hasEvents(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    final events = controller.kalenderByDate[key];
    return events != null && events.isNotEmpty;
  }

  Widget _overlayBuilder(BuildContext context, CustomRange range) {
    SekolahKalenderAkademikModel? event;
    for (final item in controller.allKalender) {
      if (item.id == range.id) {
        event = item;
        break;
      }
    }
    final label = event?.deskripsi?.trim().isNotEmpty == true
        ? event!.deskripsi!
        : 'Kalender Akademik';
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(
        vertical: MBGSizes.xs,
        horizontal: MBGSizes.sm,
      ),
      decoration: BoxDecoration(
        color: MBGColors.primary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusSm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: MBGColors.white,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _buildToolTip() {
    final events = controller.getEventsForDate(controller.selectedDate.value);
    if (events.isEmpty) {
      return 'Tidak ada event';
    }
    final keywords = events
        .map((event) => event.deskripsi)
        .whereType<String>()
        .where((text) => text.isNotEmpty)
        .toList();
    if (keywords.isEmpty) return '${events.length} event';
    return '${keywords.first} • ${events.length} event';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MBGColors.primary.withValues(alpha: 0.15),
                MBGColors.primary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
            boxShadow: [
              BoxShadow(
                color: MBGColors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(MBGSizes.sm),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: controller.focusedDate.value,
              overlayRanges: _buildOverlayRanges(),
              calendarBuilders: CalendarBuilders(
                overlayBuilder: _overlayBuilder,
              ),
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDate.value, day),
              onDaySelected: (selectedDay, focusedDay) {
                controller.selectedDate.value = selectedDay;
                controller.focusedDate.value = focusedDay;
              },
              onPageChanged: (focusedDay) {
                controller.focusedDate.value = focusedDay;
              },
              calendarFormat: CalendarFormat.month,
              eventLoader: controller.getEventsForDate,
              showTooltip: true,
              toolTip: _buildToolTip(),
              toolTipDate: controller.selectedDate.value,
              toolTipStyle: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: MBGColors.white),
              toolTipBackgroundColor: MBGColors.primary,
              markedDayPredicate: _hasEvents,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      MBGColors.primary.withValues(alpha: 0.25),
                      MBGColors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [MBGColors.primary, MBGColors.primary],
                  ),
                ),
                markerDecoration: BoxDecoration(
                  color: MBGColors.secondary,
                  shape: BoxShape.circle,
                ),
                cellMargin: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),
        Row(
          children: [
            const Icon(Iconsax.calendar_circle, size: MBGSizes.iconMd),
            const SizedBox(width: MBGSizes.xs),
            Text(
              'Event pada ${DateFormat('dd MMMM yyyy', 'id_ID').format(controller.selectedDate.value)}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
