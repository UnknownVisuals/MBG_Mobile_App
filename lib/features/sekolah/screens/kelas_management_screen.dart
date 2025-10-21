import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/http/sekolah_service.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../common/widgets/appbar.dart';
import '../models/kelas_model.dart';
import '../../authentication/controllers/user_controller.dart';

class KelasManagementScreen extends StatefulWidget {
  const KelasManagementScreen({super.key});

  @override
  State<KelasManagementScreen> createState() => _KelasManagementScreenState();
}

class _KelasManagementScreenState extends State<KelasManagementScreen> {
  final SekolahService _sekolahService = Get.find<SekolahService>();
  final UserController _userController = Get.find<UserController>();
  List<KelasModel> _kelasList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  String? get _sekolahId {
    final sekolahAsPIC = _userController.user.value?.sekolahAsPIC;
    if (sekolahAsPIC == null || sekolahAsPIC.isEmpty) return null;
    return sekolahAsPIC[0].id;
  }

  Future<void> _loadKelas() async {
    setState(() => _isLoading = true);
    try {
      final sekolahId = _sekolahId;
      if (sekolahId == null) {
        throw Exception('Anda tidak memiliki akses ke sekolah');
      }
      final kelas = await _sekolahService.getKelasBySekolah(sekolahId);
      setState(() {
        _kelasList = kelas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _showAddKelasDialog() async {
    final sekolahId = _sekolahId;
    if (sekolahId == null) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Anda tidak memiliki akses ke sekolah',
      );
      return;
    }

    final namaController = TextEditingController();
    final tingkatController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Kelas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Kelas (contoh: 1A, 2B)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tingkatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tingkat (1-6)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty ||
                  tingkatController.text.isEmpty) {
                MBGLoaders.warningSnackBar(
                  title: 'Peringatan',
                  message: 'Semua field harus diisi',
                );
                return;
              }

              final tingkat = int.tryParse(tingkatController.text);
              if (tingkat == null || tingkat < 1 || tingkat > 6) {
                MBGLoaders.warningSnackBar(
                  title: 'Peringatan',
                  message: 'Tingkat harus antara 1-6',
                );
                return;
              }

              Navigator.pop(context);
              MBGFullScreenLoader.openLoadingDialog(
                'Menyimpan kelas...',
                MBGImages.onBoardingImage1,
              );

              try {
                await _sekolahService.createKelas(sekolahId, {
                  'nama': namaController.text,
                  'tingkat': tingkat,
                });
                MBGFullScreenLoader.stopLoading();
                MBGLoaders.successSnackBar(
                  title: 'Berhasil',
                  message: 'Kelas berhasil ditambahkan',
                );
                _loadKelas();
              } catch (e) {
                MBGFullScreenLoader.stopLoading();
                MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditKelasDialog(KelasModel kelas) async {
    final namaController = TextEditingController(text: kelas.nama);
    final tingkatController = TextEditingController(
      text: kelas.tingkat.toString(),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Kelas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Kelas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tingkatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tingkat (1-6)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty ||
                  tingkatController.text.isEmpty) {
                MBGLoaders.warningSnackBar(
                  title: 'Peringatan',
                  message: 'Semua field harus diisi',
                );
                return;
              }

              final tingkat = int.tryParse(tingkatController.text);
              if (tingkat == null || tingkat < 1 || tingkat > 6) {
                MBGLoaders.warningSnackBar(
                  title: 'Peringatan',
                  message: 'Tingkat harus antara 1-6',
                );
                return;
              }

              Navigator.pop(context);
              MBGFullScreenLoader.openLoadingDialog(
                'Menyimpan perubahan...',
                MBGImages.onBoardingImage1,
              );

              try {
                await _sekolahService.updateKelas(kelas.id, {
                  'nama': namaController.text,
                  'tingkat': tingkat,
                });
                MBGFullScreenLoader.stopLoading();
                MBGLoaders.successSnackBar(
                  title: 'Berhasil',
                  message: 'Kelas berhasil diperbarui',
                );
                _loadKelas();
              } catch (e) {
                MBGFullScreenLoader.stopLoading();
                MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteKelas(String id, String nama) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus kelas "$nama"?'),
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
        'Menghapus kelas...',
        MBGImages.onBoardingImage1,
      );
      try {
        await _sekolahService.deleteKelas(id);
        MBGFullScreenLoader.stopLoading();
        MBGLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Kelas berhasil dihapus',
        );
        _loadKelas();
      } catch (e) {
        MBGFullScreenLoader.stopLoading();
        MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }

  Color _getTingkatColor(int tingkat) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow.shade700,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];
    return colors[(tingkat - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MBGAppBar(
        title: const Text('Manajemen Kelas'),
        showBackArrow: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kelasList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.class_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada kelas',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan kelas dengan tombol + di bawah',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadKelas,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: _kelasList.length,
                itemBuilder: (context, index) {
                  final kelas = _kelasList[index];
                  final color = _getTingkatColor(kelas.tingkat);

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _showEditKelasDialog(kelas),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(0.7),
                              color.withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Tingkat ${kelas.tingkat}',
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        _deleteKelas(kelas.id, kelas.nama),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                kelas.nama,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.people,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Kelas SD',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddKelasDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kelas'),
      ),
    );
  }
}
