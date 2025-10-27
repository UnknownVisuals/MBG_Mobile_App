import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/popups/loaders.dart';
import '../../controllers/dapur_controller.dart';
import '../../controllers/pengiriman_controller.dart';
import '../../../sekolah/models/sekolah_model.dart';
import 'widgets/tab_badge_widget.dart';
import 'widgets/no_dapur_selected_widget.dart';
import 'widgets/pengiriman_list_widget.dart';
import 'widgets/pengiriman_dialogs.dart';

/// Main pengiriman management screen
class PengirimanScreen extends StatelessWidget {
  const PengirimanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PengirimanController());
    final dapurController = Get.find<DapurController>();

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
                    Obx(
                      () => TabBadgeWidget(
                        count: controller.allPengiriman.length,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Pending'),
                    const SizedBox(width: 8),
                    Obx(
                      () =>
                          TabBadgeWidget(count: controller.pendingCount.value),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Dikirim'),
                    const SizedBox(width: 8),
                    Obx(
                      () => TabBadgeWidget(
                        count: controller.inTransitCount.value,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Selesai'),
                    const SizedBox(width: 8),
                    Obx(
                      () => TabBadgeWidget(
                        count: controller.completedPengiriman.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Obx(() {
          if (dapurController.isDapurLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final selectedDapur = dapurController.selectedDapur.value;
          if (selectedDapur == null) {
            return const NoDapurSelectedWidget();
          }

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              PengirimanListWidget(
                controller: controller,
                pengirimanList: controller.allPengiriman,
                onTapDetails: (pengiriman) =>
                    PengirimanDialogs.showDetailsDialog(
                      context,
                      controller,
                      pengiriman,
                    ),
                onShowQR: (pengiriman) =>
                    PengirimanDialogs.showQRCodeDialog(context, pengiriman),
                onDelete: (pengiriman) =>
                    PengirimanDialogs.showDeleteConfirmation(
                      context,
                      controller,
                      pengiriman,
                    ),
              ),
              PengirimanListWidget(
                controller: controller,
                pengirimanList: controller.pendingPengiriman,
                onTapDetails: (pengiriman) =>
                    PengirimanDialogs.showDetailsDialog(
                      context,
                      controller,
                      pengiriman,
                    ),
                onShowQR: (pengiriman) =>
                    PengirimanDialogs.showQRCodeDialog(context, pengiriman),
                onDelete: (pengiriman) =>
                    PengirimanDialogs.showDeleteConfirmation(
                      context,
                      controller,
                      pengiriman,
                    ),
              ),
              PengirimanListWidget(
                controller: controller,
                pengirimanList: controller.inTransitPengiriman,
                onTapDetails: (pengiriman) =>
                    PengirimanDialogs.showDetailsDialog(
                      context,
                      controller,
                      pengiriman,
                    ),
                onShowQR: (pengiriman) =>
                    PengirimanDialogs.showQRCodeDialog(context, pengiriman),
                onDelete: (pengiriman) =>
                    PengirimanDialogs.showDeleteConfirmation(
                      context,
                      controller,
                      pengiriman,
                    ),
              ),
              PengirimanListWidget(
                controller: controller,
                pengirimanList: controller.completedPengiriman,
                onTapDetails: (pengiriman) =>
                    PengirimanDialogs.showDetailsDialog(
                      context,
                      controller,
                      pengiriman,
                    ),
                onShowQR: (pengiriman) =>
                    PengirimanDialogs.showQRCodeDialog(context, pengiriman),
              ),
            ],
          );
        }),
        floatingActionButton: Obx(() {
          final selectedDapur = dapurController.selectedDapur.value;
          return FloatingActionButton.extended(
            onPressed: selectedDapur == null
                ? null
                : () => _showCreatePengirimanDialog(context, controller),
            icon: const Icon(Iconsax.add),
            label: const Text('Buat Pengiriman'),
          );
        }),
      ),
    );
  }

  /// Show create pengiriman dialog
  void _showCreatePengirimanDialog(
    BuildContext context,
    PengirimanController controller,
  ) {
    final dapurController = Get.find<DapurController>();
    if (dapurController.selectedDapur.value == null) {
      MBGLoaders.warningSnackBar(
        title: 'Peringatan',
        message: 'Silakan pilih dapur terlebih dahulu.',
      );
      return;
    }

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

                    if (controller.sekolahList.isEmpty) {
                      return const Text('Belum ada data sekolah tersedia.');
                    }
                    return DropdownButtonFormField<SekolahModel>(
                      initialValue: selectedSekolah,
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
}
