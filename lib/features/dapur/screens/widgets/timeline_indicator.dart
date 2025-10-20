import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/dapur/models/timeline_event_data.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_utils.dart';
import 'package:timelines_plus/timelines_plus.dart';

class CustomTimelineIndicator extends StatelessWidget {
  final TimelineEventData event;

  const CustomTimelineIndicator({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final eventColor = TimelineUtils.getEventColor(
      event.type,
      event.isCompleted,
    );

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: event.isCompleted
            ? [
                BoxShadow(
                  color: eventColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: DotIndicator(
        size: 48,
        color: eventColor,
        border: Border.all(color: Colors.white, width: 4),
        child: Icon(
          TimelineUtils.getEventIcon(event.type),
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
