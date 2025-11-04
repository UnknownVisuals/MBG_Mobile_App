import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar.dart';
import '../../controllers/sekolah_delivery_history_controller.dart';
import '../../models/sekolah_pengiriman_model.dart';
import 'widgets/delivery_history_card_widget.dart';

class DeliveryHistoryScreen extends GetView<SekolahDeliveryHistoryController> {
  const DeliveryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MBGAppBar(
        title: Text('Riwayat Pengiriman'),
        showBackArrow: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(context, 'ALL', 'Semua'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'PENDING', 'Pending'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'DIAMBIL', 'Diambil'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'DITERIMA', 'Diterima'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final deliveries = controller.filteredDeliveries;
              if (deliveries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pengiriman',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: deliveries.length,
                  itemBuilder: (context, index) {
                    final delivery = deliveries[index];

                    return DeliveryHistoryCardWidget(
                      delivery: delivery,
                      onTap: () => _showDetailDialog(context, delivery),
                      getStatusColor: controller.statusColor,
                      getStatusIcon: controller.statusIcon,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String value, String label) {
    return Obx(() {
      final isSelected = controller.filterStatus.value == value;
      return FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => controller.setFilter(value),
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      );
    });
  }

  void _showDetailDialog(
    BuildContext context,
    SekolahPengirimanModel delivery,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pengiriman'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow(
                'Status',
                delivery.status,
                controller.statusColor(delivery.status),
              ),
              const Divider(),
              _detailRow('Jumlah Tray', '${delivery.jumlahTray} tray'),
              _detailRow(
                'Jumlah Keranjang',
                '${delivery.jumlahKeranjang} keranjang',
              ),
              const Divider(),
              _detailRow('QR Code ID', delivery.qrCodeId),
              const Divider(),
              if (delivery.waktuDiambil != null)
                _detailRow(
                  'Diambil Driver',
                  controller.formatTimestamp(delivery.waktuDiambil),
                ),
              if (delivery.waktuDiterima != null)
                _detailRow(
                  'Diterima Sekolah',
                  controller.formatTimestamp(delivery.waktuDiterima),
                ),
              if (delivery.waktuDiambil != null &&
                  delivery.waktuDiterima != null) ...[
                const Divider(),
                _detailRow(
                  'Waktu Pengiriman',
                  controller.deliveryDuration(
                    delivery.waktuDiambil!,
                    delivery.waktuDiterima!,
                  ),
                  Colors.blue,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: valueColor ?? Colors.grey[700],
                fontWeight: valueColor != null ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
