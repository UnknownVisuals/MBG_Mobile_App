import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbg_mobile_app/features/sekolah/models/siswa_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/kelas_model.dart';
import 'package:mbg_mobile_app/utils/http/sekolah_service.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';

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
        final sekolahId = sekolahAsPIC[0]['id'];
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

  Color _getStatusGiziColor(String? statusGizi) {
    if (statusGizi == null) return Colors.grey;
    switch (statusGizi) {
      case 'GIZI_BAIK':
        return Colors.green;
      case 'GIZI_KURANG':
        return Colors.orange;
      case 'GIZI_BURUK':
        return Colors.red;
      case 'OBESITAS':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getStatusGiziLabel(String? statusGizi) {
    if (statusGizi == null) return 'N/A';
    return statusGizi.replaceAll('_', ' ');
  }

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
                        setDialogState(() {
                          selectedImage = File(pickedFile.path);
                        });
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
                    value: selectedKelasId,
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
                    value: selectedJenisKelamin,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'LAKI-LAKI',
                        child: Text('Laki-Laki'),
                      ),
                      DropdownMenuItem(
                        value: 'PEREMPUAN',
                        child: Text('Perempuan'),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() => selectedJenisKelamin = value!);
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
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: beratController,
                    decoration: const InputDecoration(
                      labelText: 'Berat Badan (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
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
                  if (namaController.text.isEmpty ||
                      nisController.text.isEmpty ||
                      selectedKelasId == null) {
                    Get.snackbar('Error', 'Please fill required fields');
                    return;
                  }

                  try {
                    final sekolahAsPIC =
                        _userController.user.value?.sekolahAsPIC;
                    if (sekolahAsPIC == null || sekolahAsPIC.isEmpty) return;

                    final sekolahId = sekolahAsPIC[0]['id'];

                    await _sekolahService.createSiswa(
                      sekolahId: sekolahId,
                      nama: namaController.text,
                      nis: nisController.text,
                      kelasId: selectedKelasId!,
                      jenisKelamin: selectedJenisKelamin,
                      umur: int.parse(umurController.text),
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
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: siswa.fotoUrl != null
                          ? NetworkImage(siswa.fotoUrl!)
                          : null,
                      child: siswa.fotoUrl == null ? Text(siswa.nama[0]) : null,
                    ),
                    title: Text(
                      siswa.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NIS: ${siswa.nis}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('IMT: ${siswa.imt.toStringAsFixed(1)}'),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusGiziColor(
                                  siswa.statusGizi,
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getStatusGiziLabel(siswa.statusGizi),
                                style: TextStyle(
                                  color: _getStatusGiziColor(siswa.statusGizi),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${siswa.umur} tahun • ${siswa.tinggiBadan} cm • ${siswa.beratBadan} kg',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
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
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
