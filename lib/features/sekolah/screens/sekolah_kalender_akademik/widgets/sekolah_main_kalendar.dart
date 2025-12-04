import 'package:flutter/material.dart';
import 'package:ensemble_table_calendar/ensemble_table_calendar.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kalender_akademik_controller.dart';

import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class SekolahMainKalendar extends StatelessWidget {
  const SekolahMainKalendar({super.key, required this.controller});

  final SekolahKalenderAkademikController controller;

  bool _hasEvents(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    final events = controller.kalenderByDate[key];
    return events != null && events.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final dark = MBGHelperFunctions.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        color: dark ? MBGColors.dark : MBGColors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
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
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.sm),
        child: TableCalendar(
          startingDayOfWeek: StartingDayOfWeek.monday,
          locale: 'id_ID',
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: controller.focusedDate.value,
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
          markedDayPredicate: _hasEvents,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) => const SizedBox(),
            prioritizedBuilder: (context, day, focusedDay) {
              if (_hasEvents(day)) {
                return Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: MBGColors.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: MBGColors.primary,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: dark ? MBGColors.white : MBGColors.textPrimary,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: dark ? MBGColors.white : MBGColors.darkGrey,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: dark ? MBGColors.white : MBGColors.darkGrey,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: dark ? MBGColors.grey : MBGColors.darkGrey,
            ),
            weekendStyle: const TextStyle(
              color: MBGColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(
              color: dark ? MBGColors.white : MBGColors.textPrimary,
            ),
            weekendTextStyle: const TextStyle(
              color: MBGColors.error,
              fontWeight: FontWeight.bold,
            ),
            outsideTextStyle: TextStyle(
              color: dark ? MBGColors.darkGrey : MBGColors.grey,
            ),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MBGColors.primary.withValues(alpha: 0.1),
            ),
            todayTextStyle: const TextStyle(
              color: MBGColors.primary,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MBGColors.primary,
            ),
            selectedTextStyle: const TextStyle(
              color: MBGColors.white,
              fontWeight: FontWeight.bold,
            ),
            markerDecoration: const BoxDecoration(
              color: MBGColors.secondary,
              shape: BoxShape.circle,
            ),
            cellMargin: const EdgeInsets.symmetric(vertical: 4),
          ),
        ),
      ),
    );
  }
}
