import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/timeline_event_data.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class TimelineUtils {
  // Get icon for each event type
  static IconData getEventIcon(TimelineEventType type) {
    switch (type) {
      case TimelineEventType.mulaiMemasak:
        return Iconsax.timer_start;
      case TimelineEventType.selesaiMemasak:
        return Iconsax.tick_circle;
      case TimelineEventType.selesaiPacking:
        return Iconsax.box;
      case TimelineEventType.kitchenReceived:
        return Iconsax.received;
      case TimelineEventType.washingComplete:
        return Iconsax.security;
      case TimelineEventType.schoolToDriverReturn:
        return Iconsax.truck_fast;
      case TimelineEventType.driverToKitchen:
        return Iconsax.home_2;
    }
  }

  // Get color for each event type
  static Color getEventColor(TimelineEventType type, bool isCompleted) {
    if (!isCompleted) return Colors.grey;

    switch (type) {
      case TimelineEventType.mulaiMemasak:
        return Colors.blue;
      case TimelineEventType.selesaiMemasak:
        return Colors.green;
      case TimelineEventType.selesaiPacking:
        return Colors.orange;
      case TimelineEventType.kitchenReceived:
        return Colors.purple;
      case TimelineEventType.washingComplete:
        return MBGColors.primary;
      case TimelineEventType.schoolToDriverReturn:
        return Colors.teal;
      case TimelineEventType.driverToKitchen:
        return Colors.indigo;
    }
  }

  // Get sample events - replace with actual API data
  static List<TimelineEventData> getSampleEvents() {
    return [
      TimelineEventData(
        type: TimelineEventType.mulaiMemasak,
        title: 'Mulai Memasak',
        description: 'Persiapan bahan dan mulai proses memasak',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isCompleted: true,
      ),
      TimelineEventData(
        type: TimelineEventType.selesaiMemasak,
        title: 'Selesai Memasak',
        description: 'Semua makanan telah selesai dimasak',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isCompleted: true,
      ),
      TimelineEventData(
        type: TimelineEventType.selesaiPacking,
        title: 'Selesai Packing',
        description: 'Makanan sudah dikemas dan siap dikirim',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isCompleted: false,
        isActive: true,
      ),
      TimelineEventData(
        type: TimelineEventType.kitchenReceived,
        title: 'Kitchen Received',
        description: 'Wadah makanan kembali diterima di dapur',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isCompleted: false,
        isActive: false,
      ),
      TimelineEventData(
        type: TimelineEventType.washingComplete,
        title: 'Washing Complete',
        description: 'Proses pencucian wadah selesai',
        timestamp: DateTime.now(),
        isCompleted: false,
        isActive: false,
      ),
    ];
  }
}
