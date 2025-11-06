import 'package:flutter/material.dart';

class DriverMyDeliveriesScreen extends StatelessWidget {
  const DriverMyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Deliveries')),
      body: _deliveries.isEmpty
          ? _EmptyState(message: 'Belum ada pengantaran hari ini.')
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _deliveries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final delivery = _deliveries[index];
                return _DeliveryCard(delivery: delivery);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Buka menu Checkpoint dari drawer untuk simulasi scan.',
              ),
            ),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Menu Checkpoint'),
      ),
    );
  }
}

class _MyDeliveryPreview {
  const _MyDeliveryPreview({
    required this.school,
    required this.address,
    required this.status,
    required this.trays,
    required this.baskets,
    this.pickupTime,
  });

  final String school;
  final String address;
  final String status;
  final int trays;
  final int baskets;
  final TimeOfDay? pickupTime;

  Color get statusColor {
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
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.delivery});

  final _MyDeliveryPreview delivery;

  @override
  Widget build(BuildContext context) {
    final color = delivery.statusColor;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.local_shipping, color: color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.school,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${delivery.trays} trays • ${delivery.baskets} baskets',
                        style: TextStyle(color: Colors.grey[600]),
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
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.4)),
                  ),
                  child: Text(
                    delivery.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    delivery.address,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            if (delivery.pickupTime != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Picked: ${delivery.pickupTime!.format(context)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.checklist_rtl),
                label: const Text('Update Status (Demo)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

const List<_MyDeliveryPreview> _deliveries = [
  _MyDeliveryPreview(
    school: 'SDN Harapan 1',
    address: 'Jl. Merdeka No. 12, Jakarta Pusat',
    status: 'PENDING',
    trays: 12,
    baskets: 4,
  ),
  _MyDeliveryPreview(
    school: 'SMP Negeri 5',
    address: 'Jl. Anggrek 45, Jakarta Barat',
    status: 'IN_TRANSIT',
    trays: 10,
    baskets: 3,
    pickupTime: TimeOfDay(hour: 8, minute: 45),
  ),
  _MyDeliveryPreview(
    school: 'SMA Citra Bangsa',
    address: 'Jl. Melati 3, Jakarta Selatan',
    status: 'DELIVERED',
    trays: 8,
    baskets: 2,
    pickupTime: TimeOfDay(hour: 7, minute: 30),
  ),
];
