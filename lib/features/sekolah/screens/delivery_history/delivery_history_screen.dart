import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar.dart';

/// Halaman Riwayat Pengiriman (UI Dummy - Full Adaptif Light/Dark)
class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // Dummy data
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
          // ===========================
          // FILTER CHIPS
          // ===========================
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(context, 'ALL', 'Semua', selectedFilter == 'ALL'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'PENDING', 'Pending',
                      selectedFilter == 'PENDING'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'DIAMBIL', 'Diambil',
                      selectedFilter == 'DIAMBIL'),
                  const SizedBox(width: 8),
                  _filterChip(context, 'DITERIMA', 'Diterima',
                      selectedFilter == 'DITERIMA'),
                ],
              ),
            ),
          ),

          // ===========================
          // LIST RIWAYAT
          // ===========================
          Expanded(
            child: deliveries.isEmpty
                ? _emptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: deliveries.length,
                    itemBuilder: (context, index) {
                      final item = deliveries[index];
                      return _DeliveryHistoryCard(
                        status: item['status'],
                        jumlahTray: item['jumlahTray'],
                        jumlahKeranjang: item['jumlahKeranjang'],
                        tanggal: item['tanggal'],
                        onTap: () => _showDetailDialog(context, item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER CHIP - ADAPTIF
  // ============================================================
  Widget _filterChip(
      BuildContext context, String value, String label, bool isSelected) {
    final scheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      selectedColor: scheme.primaryContainer.withOpacity(.4),
      checkmarkColor: scheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? scheme.primary : scheme.outlineVariant,
      ),
    );
  }

  // ============================================================
  // EMPTY STATE ADAPTIF
  // ============================================================
  Widget _emptyState(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 80,
            color: scheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada pengiriman',
            style: theme.textTheme.titleLarge?.copyWith(
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL DIALOG
  // ============================================================
  void _showDetailDialog(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Detail Pengiriman',
          style: theme.textTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(context, 'Status', item['status']),
            _detailRow(context, 'Jumlah Tray', '${item['jumlahTray']} tray'),
            _detailRow(context, 'Jumlah Keranjang',
                '${item['jumlahKeranjang']} keranjang'),
            _detailRow(context, 'Tanggal', item['tanggal']),
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

  Widget _detailRow(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: scheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// CARD RIWAYAT PENGIRIMAN - FULL ADAPTIF
// ===================================================================
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

  // ===========================
  // STATUS COLOR – Adaptif
  // ===========================
  Color _statusBaseColor(String status) {
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = _statusBaseColor(status);

    // Blend ke primary agar tetap kontras di dark mode
    final blendedColor = Color.alphaBlend(base.withOpacity(.7), scheme.primary);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: blendedColor.withOpacity(.35), width: 1),
      ),
      color: scheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ICON WRAPPER
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: blendedColor.withOpacity(.20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _statusIcon(status),
                  color: blendedColor,
                  size: 26,
                ),
              ),

              const SizedBox(width: 16),

              // TEXTS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // STATUS BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: blendedColor.withOpacity(.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: blendedColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '$jumlahTray tray • $jumlahKeranjang keranjang',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      tanggal,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: scheme.outlineVariant,
              )
            ],
          ),
        ),
      ),
    );
  }

  IconData _statusIcon(String status) {
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
}
