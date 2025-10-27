import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import '../../../../utils/http/dapur_service.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../common/widgets/appbar.dart';
import '../../models/karyawan_model.dart';
import 'widgets/no_dapur_selected_widget.dart';
import 'widgets/karyawan_content_widget.dart';

class KaryawanManagementScreen extends StatefulWidget {
  const KaryawanManagementScreen({super.key});

  @override
  State<KaryawanManagementScreen> createState() =>
      _KaryawanManagementScreenState();
}

class _KaryawanManagementScreenState extends State<KaryawanManagementScreen> {
  final DapurService _dapurService = Get.find<DapurService>();
  late final DapurController _dapurController;
  Worker? _dapurWorker;
  List<KaryawanModel> _karyawanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dapurController = Get.find<DapurController>();
    _dapurWorker = ever(_dapurController.selectedDapur, (_) => _loadKaryawan());
    _loadKaryawan();
  }

  Future<void> _loadKaryawan() async {
    final selectedDapur = _dapurController.selectedDapur.value;

    if (selectedDapur == null) {
      if (!mounted) return;
      setState(() {
        _karyawanList = [];
        _isLoading = false;
      });
      return;
    }

    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final karyawan = await _dapurService.getKaryawanByDapur(selectedDapur.id);
      if (!mounted) return;
      setState(() {
        _karyawanList = karyawan;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _showAddKaryawanDialog() async {
    final selectedDapur = _dapurController.selectedDapur.value;
    if (selectedDapur == null) {
      MBGLoaders.warningSnackBar(
        title: 'Peringatan',
        message: 'Silakan pilih dapur terlebih dahulu.',
      );
      return;
    }

    final nameController = TextEditingController();
    final posisiController = TextEditingController();
    File? selectedImage;
    final ImagePicker picker = ImagePicker();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah Karyawan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Photo picker
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 800,
                      maxHeight: 800,
                      imageQuality: 85,
                    );
                    if (image != null) {
                      setDialogState(() {
                        selectedImage = File(image.path);
                      });
                    }
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tambah Foto',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Karyawan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: posisiController,
                  decoration: const InputDecoration(
                    labelText: 'Posisi',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    posisiController.text.isEmpty) {
                  MBGLoaders.warningSnackBar(
                    title: 'Peringatan',
                    message: 'Nama dan Posisi harus diisi',
                  );
                  return;
                }

                Navigator.pop(context);
                MBGFullScreenLoader.openLoadingDialog(
                  'Menyimpan karyawan...',
                  MBGImages.onBoardingImage1,
                );

                try {
                  await _dapurService.createKaryawan(
                    dapurId: selectedDapur.id,
                    nama: nameController.text,
                    posisi: posisiController.text,
                    foto: selectedImage,
                  );
                  MBGFullScreenLoader.stopLoading();
                  MBGLoaders.successSnackBar(
                    title: 'Berhasil',
                    message: 'Karyawan berhasil ditambahkan',
                  );
                  _loadKaryawan();
                } catch (e) {
                  MBGFullScreenLoader.stopLoading();
                  MBGLoaders.errorSnackBar(
                    title: 'Error',
                    message: e.toString(),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dapurWorker?.dispose();
    super.dispose();
  }

  Future<void> _deleteKaryawan(String id, String nama) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus karyawan "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      MBGFullScreenLoader.openLoadingDialog(
        'Menghapus karyawan...',
        MBGImages.onBoardingImage1,
      );
      try {
        await _dapurService.deleteKaryawan(id);
        MBGFullScreenLoader.stopLoading();
        MBGLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Karyawan berhasil dihapus',
        );
        _loadKaryawan();
      } catch (e) {
        MBGFullScreenLoader.stopLoading();
        MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDapur = _dapurController.selectedDapur.value;
      final isKitchenLoading = _dapurController.isDapurLoading.value;
      final errorMessage = _dapurController.dapurError.value;

      return Scaffold(
        appBar: MBGAppBar(
          title: Text(
            selectedDapur != null
                ? 'Manajemen Karyawan (${selectedDapur.nama})'
                : 'Manajemen Karyawan',
          ),
          showBackArrow: false,
        ),
        body: isKitchenLoading && selectedDapur == null
            ? const Center(child: CircularProgressIndicator())
            : selectedDapur == null
            ? NoDapurSelectedWidget(errorMessage: errorMessage)
            : KaryawanContentWidget(
                karyawanList: _karyawanList,
                isLoading: _isLoading,
                onRefresh: _loadKaryawan,
                onDelete: _deleteKaryawan,
              ),
        floatingActionButton: selectedDapur == null
            ? null
            : FloatingActionButton.extended(
                onPressed: _showAddKaryawanDialog,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Karyawan'),
              ),
      );
    });
  }
}
