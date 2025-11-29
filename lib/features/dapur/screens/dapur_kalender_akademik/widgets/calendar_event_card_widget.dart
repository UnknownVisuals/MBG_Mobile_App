import 'package:flutter/material.dart';
import '../../../controllers/dapur_kalender_akademik_controller.dart';
import '../../../models/dapur_kalender_akademik_model.dart';

/// Event card widget for calendar events
class CalendarEventCardWidget extends StatelessWidget {
  final KalenderAkademikModel event;
  final KalenderAkademikController controller;
  final VoidCallback onTap;

  const CalendarEventCardWidget({
    super.key,
    required this.event,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = controller.getEventColor(event.jenis!);
    final icon = controller.getEventIcon(event.jenis!);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.nama!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (event.deskripsi!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.deskripsi!,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color),
                ),
                child: Text(
                  controller.getEventLabel(event.jenis!),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
