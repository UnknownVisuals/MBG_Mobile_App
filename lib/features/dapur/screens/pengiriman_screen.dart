import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../utils/popups/loaders.dart';
import '../controllers/pengiriman_controller.dart';
import '../models/pengiriman_model.dart';
import '../../sekolah/models/sekolah_model.dart';

class PengirimanScreen extends StatelessWidget {
  const PengirimanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PengirimanController());

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Pengiriman'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Row(
                  children: [
                    const Text('Semua'),
                    const SizedBox(width: 8),
                    Obx(() => _buildBadge(controller.allPengiriman.length)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Pending'),
                    const SizedBox(width: 8),
                    Obx(() => _buildBadge(controller.pendingCount.value)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Dikirim'),
                    const SizedBox(width: 8),
                    Obx(() => _buildBadge(controller.inTransitCount.value)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Selesai'),
                    const SizedBox(width: 8),
                    Obx(
                      () => _buildBadge(controller.completedPengiriman.length),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _buildPengirimanList(
                      context,
                      controller,
                      controller.allPengiriman,
                    ),
                    _buildPengirimanList(
                      context,
                      controller,
                      controller.pendingPengiriman,
                    ),
                    _buildPengirimanList(
                      context,
                      controller,
                      controller.inTransitPengiriman,
                    ),
                    _buildPengirimanList(
                      context,
                      controller,
                      controller.completedPengiriman,
                    ),
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreatePengirimanDialog(context, controller),
          icon: const Icon(Iconsax.add),
          label: const Text('Buat Pengiriman'),
        ),
      ),
    );
  }

  static Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPengirimanList(
    BuildContext context,
    PengirimanController controller,
    List<PengirimanModel> pengirimanList,
  ) {
    if (pengirimanList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.truck_fast, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada pengiriman',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat pengiriman baru dengan tombol + di bawah',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pengirimanList.length,
        itemBuilder: (context, index) {
          final pengiriman = pengirimanList[index];
          return _buildPengirimanCard(context, controller, pengiriman);
        },
      ),
    );
  }

  Widget _buildPengirimanCard(
    BuildContext context,
    PengirimanController controller,
    PengirimanModel pengiriman,
  ) {
    final statusColor = controller.getStatusColor(pengiriman.status);
    final statusText = controller.getStatusText(pengiriman.status);
    final statusIcon = controller.getStatusIcon(pengiriman.status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            _showPengirimanDetailsDialog(context, controller, pengiriman),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with school name and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pengiriman.sekolahNama ?? 'Sekolah',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                pengiriman.sekolahAlamat ??
                                    'Alamat tidak tersedia',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Tray and Keranjang info
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      Iconsax.box,
                      'Tray',
                      '${pengiriman.jumlahTray}',
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      Iconsax.box_1,
                      'Keranjang',
                      '${pengiriman.jumlahKeranjang}',
                      Colors.green,
                    ),
                  ),
                ],
              ),
              // Timeline
              if (pengiriman.waktuDiambil != null ||
                  pengiriman.waktuDiterima != null) ...[
                const SizedBox(height: 12),
                if (pengiriman.waktuDiambil != null)
                  _buildTimelineItem(
                    'Diambil Driver',
                    pengiriman.waktuDiambil!,
                    Colors.blue,
                    pengiriman.driverNama,
                  ),
                if (pengiriman.waktuDiterima != null)
                  _buildTimelineItem(
                    'Diterima Sekolah',
                    pengiriman.waktuDiterima!,
                    Colors.green,
                    null,
                  ),
              ],
              const SizedBox(height: 12),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showQRCodeDialog(context, pengiriman),
                      icon: const Icon(Iconsax.scan_barcode, size: 18),
                      label: const Text('QR Code'),
                    ),
                  ),
                  if (pengiriman.status == 'PENDING') ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _confirmDeletePengiriman(
                        context,
                        controller,
                        pengiriman,
                      ),
                      icon: const Icon(Iconsax.trash, color: Colors.red),
                      tooltip: 'Hapus',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String label,
    DateTime time,
    Color color,
    String? additionalInfo,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDateTime(time),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                if (additionalInfo != null)
                  Text(
                    additionalInfo,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  // Dialog to show pengiriman details
  void _showPengirimanDetailsDialog(
    BuildContext context,
    PengirimanController controller,
    PengirimanModel pengiriman,
  ) {
    final statusColor = controller.getStatusColor(pengiriman.status);
    final statusText = controller.getStatusText(pengiriman.status);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.truck_fast, color: statusColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Detail Pengiriman',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildDetailRow('Sekolah', pengiriman.sekolahNama ?? '-'),
                _buildDetailRow('Alamat', pengiriman.sekolahAlamat ?? '-'),
                _buildDetailRow('Jumlah Tray', '${pengiriman.jumlahTray}'),
                _buildDetailRow(
                  'Jumlah Keranjang',
                  '${pengiriman.jumlahKeranjang}',
                ),
                _buildDetailRow('Status', statusText, color: statusColor),
                if (pengiriman.driverNama != null)
                  _buildDetailRow('Driver', pengiriman.driverNama!),
                if (pengiriman.waktuDiambil != null)
                  _buildDetailRow(
                    'Waktu Diambil',
                    _formatDateTime(pengiriman.waktuDiambil!),
                  ),
                if (pengiriman.waktuDiterima != null)
                  _buildDetailRow(
                    'Waktu Diterima',
                    _formatDateTime(pengiriman.waktuDiterima!),
                  ),
                _buildDetailRow('QR Code ID', pengiriman.qrCodeId),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showQRCodeDialog(context, pengiriman);
                    },
                    icon: const Icon(Iconsax.scan_barcode),
                    label: const Text('Lihat QR Code'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: color ?? Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog to create new pengiriman
  void _showCreatePengirimanDialog(
    BuildContext context,
    PengirimanController controller,
  ) {
    final formKey = GlobalKey<FormState>();
    final jumlahTrayController = TextEditingController();
    final jumlahKeranjangController = TextEditingController();
    SekolahModel? selectedSekolah;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Buat Pengiriman Baru'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (controller.isLoadingSekolah.value) {
                      return const CircularProgressIndicator();
                    }
                    return DropdownButtonFormField<SekolahModel>(
                      value: selectedSekolah,
                      decoration: const InputDecoration(
                        labelText: 'Sekolah Tujuan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Iconsax.building),
                      ),
                      items: controller.sekolahList
                          .map(
                            (sekolah) => DropdownMenuItem(
                              value: sekolah,
                              child: Text(sekolah.nama),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSekolah = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih sekolah tujuan';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: jumlahTrayController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Tray',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.box),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan jumlah tray';
                      }
                      final number = int.tryParse(value);
                      if (number == null || number <= 0) {
                        return 'Harus berupa angka positif';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: jumlahKeranjangController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Keranjang',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.box_1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan jumlah keranjang';
                      }
                      final number = int.tryParse(value);
                      if (number == null || number <= 0) {
                        return 'Harus berupa angka positif';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext);
                  await controller.createPengiriman(
                    sekolahId: selectedSekolah!.id,
                    jumlahTray: int.parse(jumlahTrayController.text),
                    jumlahKeranjang: int.parse(jumlahKeranjangController.text),
                  );
                }
              },
              child: const Text('Buat'),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to show QR Code
  void _showQRCodeDialog(BuildContext context, PengirimanModel pengiriman) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QR Code Pengiriman',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                pengiriman.sekolahNama ?? 'Sekolah',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: QrImageView(
                  data: pengiriman.qrCodeId,
                  version: QrVersions.auto,
                  size: 250,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pengiriman.qrCodeId,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement share/print QR code
                      MBGLoaders.successSnackBar(
                        title: 'Info',
                        message: 'Fitur berbagi QR akan segera hadir',
                      );
                    },
                    icon: const Icon(Iconsax.share),
                    label: const Text('Bagikan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirm delete dialog
  void _confirmDeletePengiriman(
    BuildContext context,
    PengirimanController controller,
    PengirimanModel pengiriman,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengiriman'),
        content: Text(
          'Apakah Anda yakin ingin menghapus pengiriman ke ${pengiriman.sekolahNama}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.deletePengiriman(pengiriman);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
