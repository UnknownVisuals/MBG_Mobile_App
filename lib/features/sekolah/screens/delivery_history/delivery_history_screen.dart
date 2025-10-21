import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/appbar.dart';
import '../../../../utils/http/sekolah_service.dart';
import '../../../authentication/controllers/user_controller.dart';
import '../../../dapur/models/pengiriman_model.dart';
import 'widgets/delivery_history_card_widget.dart';

class DeliveryHistoryScreen extends StatefulWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  State<DeliveryHistoryScreen> createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends State<DeliveryHistoryScreen> {
  final SekolahService _sekolahService = Get.find<SekolahService>();
  final UserController _userController = Get.find<UserController>();
  List<PengirimanModel> _deliveryList = [];
  bool _isLoading = true;
  String _filterStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  String? get _sekolahId {
    final sekolahAsPIC = _userController.user.value?.sekolahAsPIC;
    if (sekolahAsPIC == null || sekolahAsPIC.isEmpty) return null;
    return sekolahAsPIC[0].id;
  }

  Future<void> _loadDeliveries() async {
    setState(() => _isLoading = true);
    try {
      final sekolahId = _sekolahId;
      if (sekolahId == null) {
        throw Exception('Anda tidak memiliki akses ke sekolah');
      }
      final deliveries = await _sekolahService.getPengirimanBySekolah(
        sekolahId,
      );
      setState(() {
        _deliveryList = deliveries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', e.toString());
    }
  }

  List<PengirimanModel> get _filteredDeliveries {
    if (_filterStatus == 'ALL') return _deliveryList;
    return _deliveryList.where((d) => d.status == _filterStatus).toList();
  }

  Color _getStatusColor(String status) {
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Icons.pending_actions;
      case 'DIAMBIL':
        return Icons.local_shipping;
      case 'DITERIMA':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  void _showDetailDialog(PengirimanModel delivery) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pengiriman'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                'Status',
                delivery.status,
                _getStatusColor(delivery.status),
              ),
              const Divider(),
              _buildDetailRow('Jumlah Tray', '${delivery.jumlahTray} tray'),
              _buildDetailRow(
                'Jumlah Keranjang',
                '${delivery.jumlahKeranjang} keranjang',
              ),
              const Divider(),
              _buildDetailRow('QR Code ID', delivery.qrCodeId),
              const Divider(),
              if (delivery.waktuDiambil != null) ...[
                _buildDetailRow(
                  'Diambil Driver',
                  DateFormat(
                    'dd MMM yyyy HH:mm',
                  ).format(delivery.waktuDiambil!),
                ),
              ],
              if (delivery.waktuDiterima != null) ...[
                _buildDetailRow(
                  'Diterima Sekolah',
                  DateFormat(
                    'dd MMM yyyy HH:mm',
                  ).format(delivery.waktuDiterima!),
                ),
              ],
              if (delivery.waktuDiambil != null &&
                  delivery.waktuDiterima != null) ...[
                const Divider(),
                _buildDetailRow(
                  'Waktu Pengiriman',
                  _calculateDeliveryTime(
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

  Widget _buildDetailRow(String label, String value, [Color? valueColor]) {
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

  String _calculateDeliveryTime(DateTime start, DateTime end) {
    final duration = end.difference(start);
    if (duration.inHours > 0) {
      return '${duration.inHours} jam ${duration.inMinutes % 60} menit';
    }
    return '${duration.inMinutes} menit';
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildFilterChip('ALL', 'Semua'),
                  const SizedBox(width: 8),
                  _buildFilterChip('PENDING', 'Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('DIAMBIL', 'Diambil'),
                  const SizedBox(width: 8),
                  _buildFilterChip('DITERIMA', 'Diterima'),
                ],
              ),
            ),
          ),
          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDeliveries.isEmpty
                ? Center(
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
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadDeliveries,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredDeliveries.length,
                      itemBuilder: (context, index) {
                        final delivery = _filteredDeliveries[index];

                        return DeliveryHistoryCardWidget(
                          delivery: delivery,
                          onTap: () => _showDetailDialog(delivery),
                          getStatusColor: _getStatusColor,
                          getStatusIcon: _getStatusIcon,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
