import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_timeline_event_data.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_list.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_summary.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurCheckpointScreen extends StatelessWidget {
  const DapurCheckpointScreen({super.key});

  List<TimelineEventData> _buildSampleEvents() {
    return [
      TimelineEventData(
        type: TimelineEventType.mulaiMemasak,
        title: 'Mulai Memasak',
        description: 'Persiapan bahan dan mulai proses memasak',
        timestamp: DateTime(2025, 10, 24, 6, 30),
        isCompleted: true,
        role: 'PIC_DAPUR',
      ),
      TimelineEventData(
        type: TimelineEventType.selesaiMemasak,
        title: 'Selesai Memasak',
        description: 'Semua makanan telah selesai dimasak',
        timestamp: DateTime(2025, 10, 24, 8, 0),
        isCompleted: true,
        role: 'PIC_DAPUR',
      ),
      TimelineEventData(
        type: TimelineEventType.selesaiPacking,
        title: 'Selesai Packing',
        description: 'Makanan sudah dikemas dan siap dikirim',
        timestamp: DateTime(2025, 10, 24, 9, 15),
        isCompleted: false,
        isActive: true,
        role: 'PIC_DAPUR',
      ),
      TimelineEventData(
        type: TimelineEventType.schoolToDriverReturn,
        title: 'School to Driver Return',
        description: 'Driver mengambil wadah dari sekolah',
        timestamp: DateTime(2025, 10, 24, 10, 30),
        isCompleted: false,
        role: 'DRIVER',
      ),
      TimelineEventData(
        type: TimelineEventType.driverToKitchen,
        title: 'Driver to Kitchen',
        description: 'Driver mengantar wadah kembali ke dapur',
        timestamp: DateTime(2025, 10, 24, 10, 45),
        isCompleted: false,
        role: 'DRIVER',
      ),
      TimelineEventData(
        type: TimelineEventType.kitchenReceived,
        title: 'Kitchen Received',
        description: 'Wadah makanan kembali diterima di dapur',
        timestamp: DateTime(2025, 10, 24, 11, 0),
        isCompleted: false,
        role: 'PIC_DAPUR',
      ),
      TimelineEventData(
        type: TimelineEventType.washingComplete,
        title: 'Washing Complete',
        description: 'Proses pencucian wadah selesai',
        timestamp: DateTime(2025, 10, 24, 12, 0),
        isCompleted: false,
        role: 'PIC_DAPUR',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<TimelineEventData> events = _buildSampleEvents();
    final int completedCount = events
        .where((event) => event.isCompleted)
        .length;
    final int totalCount = events.length;

    return Scaffold(
      body: SingleChildScrollView(
        padding: MBGSpacingStyles.homeScreenPadding,
        child: Column(
          children: [
            DapurCheckpointSummary(
              completedCount: completedCount,
              totalCount: totalCount,
            ),
            const SizedBox(height: MBGSizes.spaceBtwSections),
            DapurCheckpointList(events: events),
          ],
        ),
      ),
    );
  }
}
