import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Timeline item widget for pengiriman status updates
class PengirimanTimelineItemWidget extends StatelessWidget {
  final String label;
  final DateTime time;
  final Color color;
  final String? additionalInfo;

  const PengirimanTimelineItemWidget({
    super.key,
    required this.label,
    required this.time,
    required this.color,
    this.additionalInfo,
  });

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDateTime(time),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                if (additionalInfo != null)
                  Text(
                    additionalInfo!,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
