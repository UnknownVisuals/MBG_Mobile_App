import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_delivery_history_controller.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'widgets/driver_delivery_history_card.dart';

class DriverDeliveryHistoryScreen
    extends GetView<DriverDeliveryHistoryController> {
  const DriverDeliveryHistoryScreen({super.key});

  static const List<String> _statusOptions = <String>[
    'ALL',
    'PENDING',
    'IN_TRANSIT',
    'DIAMBIL',
    'DELIVERED',
    'DITERIMA',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshDeliveries,
          ),
        ],
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final filtered = controller.filteredDeliveries;
        final total = controller.deliveries.length;
        final selectedStatus = controller.selectedStatus.value;
        final range = controller.selectedDateRange.value;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: _statusOptions
                              .map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.setStatusFilter(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDateRange(context),
                          icon: const Icon(Iconsax.calendar),
                          label: Text(
                            range != null
                                ? '${DateFormat('dd/MM').format(range.start)} - ${DateFormat('dd/MM').format(range.end)}'
                                : 'Date Range',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      if (range != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: controller.clearDateRange,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Showing ${filtered.length} of $total deliveries',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading && filtered.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: controller.refreshDeliveries,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final delivery = filtered[index];
                          return DriverDeliveryHistoryCard(
                            delivery: delivery,
                            onTap: () => _showDeliveryDetail(context, delivery),
                            getStatusColor: _getStatusColor,
                            getStatusIcon: _getStatusIcon,
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final currentRange = controller.selectedDateRange.value;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: currentRange,
    );

    if (picked != null) {
      controller.setDateRange(picked);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.truck_fast, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No deliveries found',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showDeliveryDetail(BuildContext context, DriverDeliveryModel delivery) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delivery Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('School', delivery.sekolahNama ?? 'N/A'),
              const Divider(),
              _buildDetailRow('Status', delivery.status),
              const Divider(),
              _buildDetailRow('Trays', '${delivery.jumlahTray}'),
              _buildDetailRow('Baskets', '${delivery.jumlahKeranjang}'),
              const Divider(),
              _buildDetailRow('QR Code', delivery.qrCodeId),
              const Divider(),
              _buildDetailRow(
                'Created',
                DateFormat('dd MMM yyyy, HH:mm').format(delivery.createdAt),
              ),
              if (delivery.waktuDiambil != null)
                _buildDetailRow(
                  'Picked Up',
                  DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(delivery.waktuDiambil!),
                ),
              if (delivery.waktuDiterima != null)
                _buildDetailRow(
                  'Delivered',
                  DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(delivery.waktuDiterima!),
                ),
              if (delivery.waktuDiambil != null &&
                  delivery.waktuDiterima != null) ...[
                const Divider(),
                _buildDetailRow(
                  'Delivery Time',
                  _formatDuration(
                    delivery.waktuDiterima!.difference(delivery.waktuDiambil!),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0) {
      return '$minutes minutes';
    }
    return '$hours hours $minutes minutes';
  }

  Color _getStatusColor(String status) {
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Iconsax.clock;
      case 'IN_TRANSIT':
      case 'DIAMBIL':
        return Iconsax.truck_fast;
      case 'DELIVERED':
      case 'DITERIMA':
        return Iconsax.tick_circle;
      default:
        return Iconsax.info_circle;
    }
  }
}
