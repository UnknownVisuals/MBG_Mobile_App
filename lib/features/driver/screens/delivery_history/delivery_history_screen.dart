import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/models/pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/http/driver_service.dart';
import 'widgets/driver_delivery_history_card_widget.dart';

class DeliveryHistoryScreen extends StatefulWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  State<DeliveryHistoryScreen> createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends State<DeliveryHistoryScreen> {
  final DriverService _driverService = Get.find<DriverService>();
  List<PengirimanModel> _deliveries = [];
  List<PengirimanModel> _filteredDeliveries = [];
  bool _isLoading = false;
  String _selectedStatus = 'ALL';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
    setState(() => _isLoading = true);
    try {
      final deliveries = await _driverService.getMyDeliveries();
      setState(() {
        _deliveries = deliveries;
        _applyFilters();
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load deliveries: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredDeliveries = _deliveries.where((delivery) {
        // Status filter
        if (_selectedStatus != 'ALL' && delivery.status != _selectedStatus) {
          return false;
        }

        // Date range filter
        if (_startDate != null && _endDate != null) {
          final deliveryDate = delivery.createdAt;
          if (deliveryDate.isBefore(_startDate!) ||
              deliveryDate.isAfter(_endDate!.add(const Duration(days: 1)))) {
            return false;
          }
        }

        return true;
      }).toList();

      // Sort by date descending (newest first)
      _filteredDeliveries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
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
        return Iconsax.clock;
      case 'DIAMBIL':
        return Iconsax.truck_fast;
      case 'DITERIMA':
        return Iconsax.tick_circle;
      default:
        return Iconsax.info_circle;
    }
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _applyFilters();
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _applyFilters();
    });
  }

  void _showDeliveryDetail(PengirimanModel delivery) {
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
              if (delivery.waktuDiambil != null) ...[
                _buildDetailRow(
                  'Picked Up',
                  DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(delivery.waktuDiambil!),
                ),
              ],
              if (delivery.waktuDiterima != null) ...[
                _buildDetailRow(
                  'Delivered',
                  DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(delivery.waktuDiterima!),
                ),
              ],
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
    return '$hours hours $minutes minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDeliveries,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: ['ALL', 'PENDING', 'DIAMBIL', 'DITERIMA']
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStatus = value;
                              _applyFilters();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectDateRange,
                        icon: const Icon(Iconsax.calendar),
                        label: Text(
                          _startDate != null && _endDate != null
                              ? '${DateFormat('dd/MM').format(_startDate!)} - ${DateFormat('dd/MM').format(_endDate!)}'
                              : 'Date Range',
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (_startDate != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearDateFilter,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Showing ${_filteredDeliveries.length} of ${_deliveries.length} deliveries',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
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
                          Iconsax.truck_fast,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No deliveries found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadDeliveries,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredDeliveries.length,
                      itemBuilder: (context, index) {
                        final delivery = _filteredDeliveries[index];

                        return DriverDeliveryHistoryCardWidget(
                          delivery: delivery,
                          onTap: () => _showDeliveryDetail(delivery),
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
}
