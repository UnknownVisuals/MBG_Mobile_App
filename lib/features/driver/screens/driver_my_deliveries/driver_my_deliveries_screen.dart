import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_my_deliveries_controller.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_my_deliveries/widgets/driver_my_delivery_card.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_qr_scanner/driver_qr_scanner_screen.dart';

class DriverMyDeliveriesScreen extends GetView<DriverMyDeliveriesController> {
  const DriverMyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Deliveries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshDeliveries,
          ),
        ],
      ),
      body: Obx(() {
        final deliveries = controller.deliveries;

        if (controller.isLoading.value && deliveries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (deliveries.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDeliveries,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              final delivery = deliveries[index];
              return DriverMyDeliveryCard(
                delivery: delivery,
                onScan: () => _handleScan(context),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleScan(context),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan QR'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }

  Future<void> _handleScan(BuildContext context) async {
    final DriverDeliveryModel? result = await Get.to<DriverDeliveryModel?>(
      () => const DriverQrScannerScreen(),
    );
    if (result != null) {
      controller.upsertDelivery(result);
    }
  }
}
