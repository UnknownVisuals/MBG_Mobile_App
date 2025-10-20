import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/dapur/models/timeline_event_data.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_event_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimelineList extends StatelessWidget {
  const TimelineList({
    super.key,
    required this.scrollController,
    required this.events,
    required this.cardKeys,
  });

  final ScrollController scrollController;
  final List<TimelineEventData> events;
  final List<GlobalKey> cardKeys;

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      controller: scrollController,
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
            child: Container(
              key: cardKeys[index],
              child: TimelineEventCard(event: event),
            ),
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
