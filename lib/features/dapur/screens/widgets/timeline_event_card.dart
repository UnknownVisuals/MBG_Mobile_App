import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/timeline_event_data.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_utils.dart';

class TimelineEventCard extends StatelessWidget {
  final TimelineEventData event;

  const TimelineEventCard({super.key, required this.event});

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final eventColor = TimelineUtils.getEventColor(
      event.type,
      event.isCompleted,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: event.isCompleted
            ? LinearGradient(
                colors: [Colors.white, eventColor.withValues(alpha: .05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: event.isCompleted ? null : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: event.isCompleted
              ? eventColor.withValues(alpha: 0.3)
              : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: event.isCompleted
            ? [
                BoxShadow(
                  color: eventColor.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon badge
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: event.isCompleted
                        ? eventColor.withValues(alpha: 0.15)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    TimelineUtils.getEventIcon(event.type),
                    color: event.isCompleted ? eventColor : Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Title and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: event.isCompleted
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 14,
                            color: event.isCompleted ? eventColor : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(event.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: event.isCompleted
                                  ? eventColor
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: event.isCompleted
                        ? LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                          )
                        : null,
                    color: event.isCompleted ? null : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: event.isCompleted
                        ? [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        event.isCompleted
                            ? Iconsax.tick_circle5
                            : Iconsax.timer_pause,
                        size: 14,
                        color: event.isCompleted
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.isCompleted ? 'Selesai' : 'Pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: event.isCompleted
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: event.isCompleted ? Colors.white : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: event.isCompleted
                      ? eventColor.withValues(alpha: 0.2)
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.document_text,
                    size: 16,
                    color: event.isCompleted
                        ? eventColor.withValues(alpha: 0.7)
                        : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: event.isCompleted
                            ? Colors.black87
                            : Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
