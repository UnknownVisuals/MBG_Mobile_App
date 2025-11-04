import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_timeline_event_data.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:timelines_plus/timelines_plus.dart';

class DapurCheckpointList extends StatelessWidget {
  const DapurCheckpointList({super.key, required this.events});

  final List<TimelineEventData> events;

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(nodePosition: 0),
      builder: TimelineTileBuilder.connected(
        itemCount: events.length,
        contentsBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.only(
              left: MBGSizes.spaceBtwItems,
              bottom: MBGSizes.spaceBtwItems,
            ),
            child: DapurCheckpointEventCard(event: event),
          );
        },
        indicatorBuilder: (context, index) {
          final event = events[index];
          final bool shouldHighlight = event.isCompleted || event.isActive;
          return OutlinedDotIndicator(
            color: shouldHighlight ? MBGColors.primary : MBGColors.grey,
          );
        },
        connectorBuilder: (context, index, connectorType) {
          final event = events[index];
          final bool isConnectorActive = event.isCompleted;
          return DashedLineConnector(
            color: isConnectorActive ? MBGColors.primary : MBGColors.grey,
          );
        },
      ),
    );
  }
}
