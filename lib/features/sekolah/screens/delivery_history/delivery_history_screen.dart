import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar.dart';

/// Halaman Riwayat Pengiriman (versi dummy UI tanpa controller)
class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk preview UI
    final List<Map<String, dynamic>> deliveries = [
      {
        'status': 'PENDING',
        'jumlahTray': 10,
        'jumlahKeranjang': 3,
        'tanggal': '01 Nov 2025 08:00',
      },
      {
        'status': 'DIAMBIL',
        'jumlahTray': 8,
        'jumlahKeranjang': 2,
        'tanggal': '02 Nov 2025 09:30',
      },
      {
        'status': 'DITERIMA',
        'jumlahTray': 12,
        'jumlahKeranjang': 4,
        'tanggal': '03 Nov 2025 10:15',
      },
    ];

    String selectedFilter = 'ALL';

    return Scaffold(
      appBar: const MBGAppBar(
        title: Text('Riwayat Pengiriman'),
        showBackArrow: false,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(context, 'ALL', 'Semua', selectedFilter == 'ALL'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'PENDING', 'Pending', selectedFilter == 'PENDING'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'DIAMBIL', 'Diambil', selectedFilter == 'DIAMBIL'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'DITERIMA', 'Diterima', selectedFilter == 'DITERIMA'),
                ],
              ),
            ),
          ),

          // List Riwayat
          Expanded(
            child: deliveries.isEmpty
                ? _emptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: deliveries.length,
                    itemBuilder: (context, index) {
                      final item = deliveries[index];

                      return _DeliveryHistoryCard(
                        status: item['status'] as String,
                        jumlahTray: item['jumlahTray'] as int,
                        jumlahKeranjang: item['jumlahKeranjang'] as int,
                        tanggal: item['tanggal'] as String,
                        onTap: () => _showDetailDialog(context, item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
      BuildContext context, String value, String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
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

  void _showDetailDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pengiriman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Status', item['status'] as String),
            _detailRow('Jumlah Tray', '${item['jumlahTray']} tray'),
            _detailRow('Jumlah Keranjang', '${item['jumlahKeranjang']} keranjang'),
            _detailRow('Tanggal', item['tanggal'] as String),
          ],
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget card sederhana untuk riwayat pengiriman
class _DeliveryHistoryCard extends StatelessWidget {
  final String status;
  final int jumlahTray;
  final int jumlahKeranjang;
  final String tanggal;
  final VoidCallback onTap;

  const _DeliveryHistoryCard({
    required this.status,
    required this.jumlahTray,
    required this.jumlahKeranjang,
    required this.tanggal,
    required this.onTap,
  });

  Color get _statusColor {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'DIAMBIL':
        return Colors.blue;
      case 'DITERIMA':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData get _statusIcon {
    switch (status) {
      case 'PENDING':
        return Iconsax.timer_1;
      case 'DIAMBIL':
        return Iconsax.truck_fast;
      case 'DITERIMA':
        return Iconsax.tick_circle;
      default:
        return Iconsax.info_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _statusColor.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_statusIcon, color: _statusColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: _statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$jumlahTray tray • $jumlahKeranjang keranjang',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tanggal,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../common/widgets/appbar.dart';
// import '../../controllers/sekolah_delivery_history_controller.dart';
// import '../../models/sekolah_pengiriman_model.dart';
// import 'widgets/delivery_history_card_widget.dart';

// class DeliveryHistoryScreen extends GetView<SekolahDeliveryHistoryController> {
//   const DeliveryHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const MBGAppBar(
//         title: Text('Riwayat Pengiriman'),
//         showBackArrow: false,
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _filterChip(context, 'ALL', 'Semua'),
//                   const SizedBox(width: 8),
//                   _filterChip(context, 'PENDING', 'Pending'),
//                   const SizedBox(width: 8),
//                   _filterChip(context, 'DIAMBIL', 'Diambil'),
//                   const SizedBox(width: 8),
//                   _filterChip(context, 'DITERIMA', 'Diterima'),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final deliveries = controller.filteredDeliveries;
//               if (deliveries.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.local_shipping_outlined,
//                         size: 80,
//                         color: Colors.grey[400],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Belum ada pengiriman',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: controller.refresh,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: deliveries.length,
//                   itemBuilder: (context, index) {
//                     final delivery = deliveries[index];

//                     return DeliveryHistoryCardWidget(
//                       delivery: delivery,
//                       onTap: () => _showDetailDialog(context, delivery),
//                       getStatusColor: controller.statusColor,
//                       getStatusIcon: controller.statusIcon,
//                     );
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _filterChip(BuildContext context, String value, String label) {
//     return Obx(() {
//       final isSelected = controller.filterStatus.value == value;
//       return FilterChip(
//         label: Text(label),
//         selected: isSelected,
//         onSelected: (_) => controller.setFilter(value),
//         selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
//         checkmarkColor: Theme.of(context).primaryColor,
//         labelStyle: TextStyle(
//           color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//       );
//     });
//   }

//   void _showDetailDialog(
//     BuildContext context,
//     SekolahPengirimanModel delivery,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Detail Pengiriman'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _detailRow(
//                 'Status',
//                 delivery.status,
//                 controller.statusColor(delivery.status),
//               ),
//               const Divider(),
//               _detailRow('Jumlah Tray', '${delivery.jumlahTray} tray'),
//               _detailRow(
//                 'Jumlah Keranjang',
//                 '${delivery.jumlahKeranjang} keranjang',
//               ),
//               const Divider(),
//               _detailRow('QR Code ID', delivery.qrCodeId),
//               const Divider(),
//               if (delivery.waktuDiambil != null)
//                 _detailRow(
//                   'Diambil Driver',
//                   controller.formatTimestamp(delivery.waktuDiambil),
//                 ),
//               if (delivery.waktuDiterima != null)
//                 _detailRow(
//                   'Diterima Sekolah',
//                   controller.formatTimestamp(delivery.waktuDiterima),
//                 ),
//               if (delivery.waktuDiambil != null &&
//                   delivery.waktuDiterima != null) ...[
//                 const Divider(),
//                 _detailRow(
//                   'Waktu Pengiriman',
//                   controller.deliveryDuration(
//                     delivery.waktuDiambil!,
//                     delivery.waktuDiterima!,
//                   ),
//                   Colors.blue,
//                 ),
//               ],
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Tutup'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _detailRow(String label, String value, [Color? valueColor]) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: valueColor ?? Colors.grey[700],
//                 fontWeight: valueColor != null ? FontWeight.w600 : null,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
