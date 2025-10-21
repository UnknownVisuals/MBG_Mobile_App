import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/http/dapur_service.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../common/widgets/appbar.dart';
import '../models/karyawan_model.dart';

class KaryawanManagementScreen extends StatefulWidget {
  const KaryawanManagementScreen({super.key});

  @override
  State<KaryawanManagementScreen> createState() =>
      _KaryawanManagementScreenState();
}

class _KaryawanManagementScreenState extends State<KaryawanManagementScreen> {
  final DapurService _dapurService = Get.find<DapurService>();
  List<KaryawanModel> _karyawanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKaryawan();
  }

  Future<void> _loadKaryawan() async {
    setState(() => _isLoading = true);
    try {
      final karyawan = await _dapurService.getAllKaryawan();
      setState(() {
        _karyawanList = karyawan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _showAddKaryawanDialog() async {
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
    return Scaffold(
      appBar: MBGAppBar(
        title: const Text('Manajemen Karyawan'),
        showBackArrow: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _karyawanList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada karyawan',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan karyawan dengan tombol + di bawah',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadKaryawan,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _karyawanList.length,
                itemBuilder: (context, index) {
                  final karyawan = _karyawanList[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Photo
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: karyawan.fotoUrl != null
                                ? Image.network(
                                    karyawan.fotoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.person,
                                                size: 60,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        // Info
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  karyawan.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  karyawan.posisi,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 20),
                                      color: Colors.red,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _deleteKaryawan(
                                        karyawan.id,
                                        karyawan.nama,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddKaryawanDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Karyawan'),
      ),
    );
  }
}
