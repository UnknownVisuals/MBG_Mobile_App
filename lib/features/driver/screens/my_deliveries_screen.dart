import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/models/pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/http/driver_service.dart';
import 'package:mbg_mobile_app/features/driver/screens/qr_scanner_screen.dart';

class MyDeliveriesScreen extends StatefulWidget {
  const MyDeliveriesScreen({super.key});

  @override
  State<MyDeliveriesScreen> createState() => _MyDeliveriesScreenState();
}

class _MyDeliveriesScreenState extends State<MyDeliveriesScreen> {
  final DriverService _driverService = Get.find<DriverService>();
  List<PengirimanModel> _deliveries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
    setState(() => _isLoading = true);
    try {
      final data = await _driverService.getMyDeliveries();
      setState(() => _deliveries = data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load deliveries: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _scanQRCode() async {
    final result = await Get.to(() => const QRScannerScreen());
    if (result != null) {
      // Refresh the list after successful scan
      _loadDeliveries();
    }
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
        return Icons.schedule;
      case 'DIAMBIL':
        return Icons.local_shipping;
      case 'DITERIMA':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Deliveries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDeliveries,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _deliveries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No deliveries assigned',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadDeliveries,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _deliveries.length,
                itemBuilder: (context, index) {
                  final delivery = _deliveries[index];
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
                                _getStatusIcon(delivery.status),
                                color: _getStatusColor(delivery.status),
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
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
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
                                  color: _getStatusColor(
                                    delivery.status,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getStatusColor(delivery.status),
                                  ),
                                ),
                                child: Text(
                                  delivery.status,
                                  style: TextStyle(
                                    color: _getStatusColor(delivery.status),
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
                              Icon(
                                Icons.school,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  delivery.sekolahAlamat ??
                                      'Address not available',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              const Spacer(),
                              if (delivery.waktuDiambil != null) ...[
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
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
                                onPressed: _scanQRCode,
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
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanQRCode,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan QR'),
      ),
    );
  }
}
