import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/http/sekolah_service.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../authentication/controllers/user_controller.dart';
import '../../models/alergi_model.dart';
import '../../models/kelas_model.dart';
import '../../models/siswa_model.dart';
import 'widgets/siswa_card_widget.dart';

/// Main siswa management screen
class SiswaManagementScreen extends StatefulWidget {
  const SiswaManagementScreen({super.key});

  @override
  State<SiswaManagementScreen> createState() => _SiswaManagementScreenState();
}

class _SiswaManagementScreenState extends State<SiswaManagementScreen> {
  final SekolahService _sekolahService = Get.find<SekolahService>();
  final UserController _userController = Get.find<UserController>();
  List<SiswaModel> _siswaList = [];
  List<KelasModel> _kelasList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final sekolahAsPIC = _userController.user.value?.sekolahAsPIC;
      if (sekolahAsPIC != null && sekolahAsPIC.isNotEmpty) {
        final sekolahId = sekolahAsPIC[0].id;
        final students = await _sekolahService.getSiswaBySekolah(sekolahId);
        final classes = await _sekolahService.getKelasBySekolah(sekolahId);
        setState(() {
          _siswaList = students;
          _kelasList = classes;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siswa Management'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _siswaList.isEmpty
          ? const Center(child: Text('No students found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _siswaList.length,
              itemBuilder: (context, index) {
                final siswa = _siswaList[index];
                return SiswaCardWidget(
                  siswa: siswa,
                  onTap: () => _showAlergiDialog(siswa),
                  onDelete: () => _confirmDelete(siswa),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Confirm delete dialog
  Future<void> _confirmDelete(SiswaModel siswa) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Delete ${siswa.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _sekolahService.deleteSiswa(siswa.id);
        Get.snackbar('Success', 'Student deleted');
        _loadData();
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete: $e');
      }
    }
  }

  /// Show allergy dialog
  void _showAlergiDialog(SiswaModel siswa) {
    final RxList<AlergiModel> alergies = <AlergiModel>[].obs;
    final TextEditingController alergiController = TextEditingController();

    // Load allergies
    Future<void> loadAlergi() async {
      try {
        final result = await _sekolahService.getAlergiBySiswa(siswa.id);
        alergies.value = result;
      } catch (e) {
        MBGLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to load allergies: $e',
        );
      }
    }

    loadAlergi();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Alergi - ${siswa.nama}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: alergies.map((alergi) {
                    return Chip(
                      label: Text(alergi.namaAlergi),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () async {
                        final confirm = await Get.dialog<bool>(
                          AlertDialog(
                            title: const Text('Hapus Alergi'),
                            content: Text(
                              'Hapus alergi "${alergi.namaAlergi}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () => Get.back(result: true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await _sekolahService.deleteAlergi(alergi.id);
                            MBGLoaders.successSnackBar(
                              title: 'Berhasil',
                              message: 'Alergi berhasil dihapus',
                            );
                            loadAlergi();
                          } catch (e) {
                            MBGLoaders.errorSnackBar(
                              title: 'Error',
                              message: 'Gagal menghapus alergi: $e',
                            );
                          }
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: alergiController,
                      decoration: const InputDecoration(
                        hintText: 'Tambah alergi baru...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Iconsax.add_circle),
                    color: Colors.blue,
                    iconSize: 36,
                    onPressed: () async {
                      if (alergiController.text.trim().isEmpty) {
                        MBGLoaders.warningSnackBar(
                          title: 'Peringatan',
                          message: 'Nama alergi tidak boleh kosong',
                        );
                        return;
                      }

                      try {
                        await _sekolahService.addAlergi(
                          siswa.id,
                          alergiController.text.trim(),
                        );
                        MBGLoaders.successSnackBar(
                          title: 'Berhasil',
                          message: 'Alergi berhasil ditambahkan',
                        );
                        alergiController.clear();
                        loadAlergi();
                      } catch (e) {
                        MBGLoaders.errorSnackBar(
                          title: 'Error',
                          message: 'Gagal menambah alergi: $e',
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show create student dialog
  void _showCreateDialog() {
    final namaController = TextEditingController();
    final nisController = TextEditingController();
    final umurController = TextEditingController();
    final tinggiController = TextEditingController();
    final beratController = TextEditingController();
    String? selectedKelasId;
    String selectedJenisKelamin = 'LAKI-LAKI';
    File? selectedImage;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Student'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Photo picker
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setDialogState(
                          () => selectedImage = File(pickedFile.path),
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                        image: selectedImage != null
                            ? DecorationImage(
                                image: FileImage(selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: selectedImage == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nisController,
                    decoration: const InputDecoration(
                      labelText: 'NIS',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedKelasId,
                    decoration: const InputDecoration(
                      labelText: 'Kelas',
                      border: OutlineInputBorder(),
                    ),
                    items: _kelasList.map((kelas) {
                      return DropdownMenuItem(
                        value: kelas.id,
                        child: Text('${kelas.tingkat} ${kelas.nama}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() => selectedKelasId = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedJenisKelamin,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'LAKI-LAKI',
                        child: Text('Laki-laki'),
                      ),
                      DropdownMenuItem(
                        value: 'PEREMPUAN',
                        child: Text('Perempuan'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedJenisKelamin = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: umurController,
                    decoration: const InputDecoration(
                      labelText: 'Umur (tahun)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tinggiController,
                    decoration: const InputDecoration(
                      labelText: 'Tinggi Badan (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: beratController,
                    decoration: const InputDecoration(
                      labelText: 'Berat Badan (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedKelasId == null) {
                    Get.snackbar('Error', 'Please select a class');
                    return;
                  }

                  try {
                    final sekolahAsPIC =
                        _userController.user.value?.sekolahAsPIC;
                    if (sekolahAsPIC == null || sekolahAsPIC.isEmpty) {
                      Get.snackbar('Error', 'Sekolah ID not found');
                      return;
                    }
                    final sekolahId = sekolahAsPIC[0].id;

                    await _sekolahService.createSiswa(
                      sekolahId: sekolahId,
                      kelasId: selectedKelasId!,
                      nama: namaController.text,
                      nis: nisController.text,
                      umur: int.parse(umurController.text),
                      jenisKelamin: selectedJenisKelamin,
                      tinggiBadan: double.parse(tinggiController.text),
                      beratBadan: double.parse(beratController.text),
                      foto: selectedImage,
                    );
                    Get.back();
                    Get.snackbar('Success', 'Student added successfully');
                    _loadData();
                  } catch (e) {
                    Get.snackbar('Error', 'Failed to add student: $e');
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}
