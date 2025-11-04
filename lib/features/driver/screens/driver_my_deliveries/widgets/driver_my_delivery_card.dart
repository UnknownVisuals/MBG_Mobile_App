import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';

typedef DriverDeliveryAction = Future<void> Function();

typedef DriverDeliveryCallback = void Function();

/// Card widget that represents a delivery assigned to the driver.
class DriverMyDeliveryCard extends StatelessWidget {
  const DriverMyDeliveryCard({
    super.key,
    required this.delivery,
    required this.onScan,
  });

  final DriverDeliveryModel delivery;
  final DriverDeliveryCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _statusIcon(delivery.status),
                  color: _statusColor(delivery.status),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.sekolahNama ?? 'Unknown School',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${delivery.jumlahTray} trays, ${delivery.jumlahKeranjang} baskets',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(delivery.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _statusColor(delivery.status)),
                  ),
                  child: Text(
                    delivery.status,
                    style: TextStyle(
                      color: _statusColor(delivery.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.school, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    delivery.sekolahAlamat ?? 'Address not available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const Spacer(),
                if (delivery.waktuDiambil != null) ...[
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Picked: ${DateFormat('HH:mm').format(delivery.waktuDiambil!)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            if (delivery.status == 'PENDING') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onScan,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan to Pick Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'IN_TRANSIT':
      case 'DIAMBIL':
        return Colors.blue;
      case 'DELIVERED':
      case 'DITERIMA':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static IconData _statusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Icons.schedule;
      case 'IN_TRANSIT':
      case 'DIAMBIL':
        return Icons.local_shipping;
      case 'DELIVERED':
      case 'DITERIMA':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }
}
