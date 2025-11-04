import 'package:flutter/material.dart';

class SiswaManagementScreen extends StatelessWidget {
  const SiswaManagementScreen({super.key});

  // Dummy data sementara (nanti bisa diganti dari controller/model)
  List<Map<String, dynamic>> get siswaList => [
        {
          'nama': 'Alya Pramudita',
          'nis': '12045',
          'umur': 10,
          'jenisKelamin': 'Perempuan',
          'statusGizi': 'Baik',
        },
        {
          'nama': 'Rafi Alamsyah',
          'nis': '12046',
          'umur': 11,
          'jenisKelamin': 'Laki-laki',
          'statusGizi': 'Kurang',
        },
        {
          'nama': 'Nadia Kurnia',
          'nis': '12047',
          'umur': 10,
          'jenisKelamin': 'Perempuan',
          'statusGizi': 'Lebih',
        },
      ];

  void _showAlergiDialog(BuildContext context, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Alergi'),
        content: Text('Siswa $nama tidak memiliki alergi tercatat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Siswa'),
        content: Text('Apakah Anda yakin ingin menghapus data $nama?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data $nama berhasil dihapus.')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Data Siswa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: siswaList.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada data siswa.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.separated(
                itemCount: siswaList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final siswa = siswaList[index];
                  return _SiswaCardWidget(
                    nama: siswa['nama']?.toString() ?? '',
                    nis: siswa['nis']?.toString() ?? '',
                    umur: int.tryParse(siswa['umur'].toString()) ?? 0,
                    jenisKelamin: siswa['jenisKelamin']?.toString() ?? '',
                    statusGizi: siswa['statusGizi']?.toString() ?? '',
                    onTap: () => _showAlergiDialog(
                        context, siswa['nama']?.toString() ?? ''),
                    onDelete: () => _confirmDelete(
                        context, siswa['nama']?.toString() ?? ''),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur tambah siswa belum tersedia.')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SiswaCardWidget extends StatelessWidget {
  final String nama;
  final String nis;
  final int umur;
  final String jenisKelamin;
  final String statusGizi;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SiswaCardWidget({
    required this.nama,
    required this.nis,
    required this.umur,
    required this.jenisKelamin,
    required this.statusGizi,
    required this.onTap,
    required this.onDelete,
  });

  Color _getGiziColor() {
    switch (statusGizi.toLowerCase()) {
      case 'baik':
        return Colors.green;
      case 'kurang':
        return Colors.orange;
      case 'lebih':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('NIS: $nis'),
                    Text('Umur: $umur tahun'),
                    Text('Jenis Kelamin: $jenisKelamin'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text('Status Gizi: '),
                        Chip(
                          label: Text(statusGizi),
                          backgroundColor: _getGiziColor().withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: _getGiziColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:iconsax/iconsax.dart';

// import '../../../../utils/popups/loaders.dart';
// import '../../controllers/sekolah_siswa_management_controller.dart';
// import '../../models/sekolah_alergi_model.dart';
// import '../../models/sekolah_kelas_model.dart';
// import '../../models/sekolah_siswa_model.dart';
// import 'widgets/siswa_card_widget.dart';

// class SiswaManagementScreen extends GetView<SekolahSiswaManagementController> {
//   const SiswaManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Siswa Management'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: controller.refreshData,
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final siswaList = controller.siswaList;
//         if (siswaList.isEmpty) {
//           return const Center(child: Text('No students found'));
//         }

//         return RefreshIndicator(
//           onRefresh: controller.refreshData,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: siswaList.length,
//             itemBuilder: (context, index) {
//               final siswa = siswaList[index];
//               return SiswaCardWidget(
//                 siswa: siswa,
//                 onTap: () => _showAlergiDialog(context, siswa),
//                 onDelete: () => _confirmDelete(context, siswa),
//               );
//             },
//           ),
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showCreateDialog,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Future<void> _confirmDelete(
//     BuildContext context,
//     SekolahSiswaModel siswa,
//   ) async {
//     final confirm = await Get.dialog<bool>(
//       AlertDialog(
//         title: const Text('Delete Student'),
//         content: Text('Delete ${siswa.nama}?'),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(result: false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Get.back(result: true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await controller.deleteSiswa(siswa);
//     }
//   }

//   Future<void> _showAlergiDialog(
//     BuildContext context,
//     SekolahSiswaModel siswa,
//   ) async {
//     final RxList<SekolahAlergiModel> alergies = <SekolahAlergiModel>[].obs;
//     final TextEditingController alergiController = TextEditingController();

//     Future<void> loadAlergi() async {
//       final result = await controller.fetchAlergi(siswa.id);
//       alergies.assignAll(result);
//     }

//     await loadAlergi();

//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Alergi - ${siswa.nama}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Get.back(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Obx(
//                 () => alergies.isEmpty
//                     ? const Text('Belum ada alergi')
//                     : Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: alergies.map((alergi) {
//                           return Chip(
//                             label: Text(alergi.namaAlergi),
//                             deleteIcon: const Icon(Icons.close, size: 18),
//                             onDeleted: () async {
//                               final confirm = await Get.dialog<bool>(
//                                 AlertDialog(
//                                   title: const Text('Hapus Alergi'),
//                                   content: Text(
//                                     'Hapus alergi "${alergi.namaAlergi}"?',
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Get.back(result: false),
//                                       child: const Text('Batal'),
//                                     ),
//                                     ElevatedButton(
//                                       onPressed: () => Get.back(result: true),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.red,
//                                       ),
//                                       child: const Text('Hapus'),
//                                     ),
//                                   ],
//                                 ),
//                               );

//                               if (confirm == true) {
//                                 final success = await controller.deleteAlergi(
//                                   alergi.id,
//                                 );
//                                 if (success) {
//                                   await loadAlergi();
//                                 }
//                               }
//                             },
//                           );
//                         }).toList(),
//                       ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: alergiController,
//                       decoration: const InputDecoration(
//                         hintText: 'Tambah alergi baru...',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Iconsax.add_circle),
//                     color: Colors.blue,
//                     iconSize: 36,
//                     onPressed: () async {
//                       final namaAlergi = alergiController.text.trim();
//                       if (namaAlergi.isEmpty) {
//                         MBGLoaders.warningSnackBar(
//                           title: 'Peringatan',
//                           message: 'Nama alergi tidak boleh kosong',
//                         );
//                         return;
//                       }

//                       final success = await controller.addAlergi(
//                         siswa.id,
//                         namaAlergi,
//                       );
//                       if (success) {
//                         alergiController.clear();
//                         await loadAlergi();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _showCreateDialog() async {
//     final namaController = TextEditingController();
//     final nisController = TextEditingController();
//     final umurController = TextEditingController();
//     final tinggiController = TextEditingController();
//     final beratController = TextEditingController();
//     String? selectedKelasId;
//     String selectedJenisKelamin = 'LAKI-LAKI';
//     File? selectedImage;

//     Get.dialog(
//       StatefulBuilder(
//         builder: (context, setDialogState) {
//           final List<SekolahKelasModel> kelasList = controller.kelasList
//               .toList();

//           return AlertDialog(
//             title: const Text('Add Student'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       final picker = ImagePicker();
//                       final pickedFile = await picker.pickImage(
//                         source: ImageSource.gallery,
//                       );
//                       if (pickedFile != null) {
//                         setDialogState(
//                           () => selectedImage = File(pickedFile.path),
//                         );
//                       }
//                     },
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         shape: BoxShape.circle,
//                         image: selectedImage != null
//                             ? DecorationImage(
//                                 image: FileImage(selectedImage!),
//                                 fit: BoxFit.cover,
//                               )
//                             : null,
//                       ),
//                       child: selectedImage == null
//                           ? const Icon(
//                               Icons.camera_alt,
//                               size: 40,
//                               color: Colors.grey,
//                             )
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: namaController,
//                     decoration: const InputDecoration(
//                       labelText: 'Nama',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: nisController,
//                     decoration: const InputDecoration(
//                       labelText: 'NIS',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     initialValue: selectedKelasId,
//                     decoration: const InputDecoration(
//                       labelText: 'Kelas',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: kelasList.map((kelas) {
//                       return DropdownMenuItem(
//                         value: kelas.id,
//                         child: Text('${kelas.tingkat} ${kelas.nama}'),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setDialogState(() => selectedKelasId = value);
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     initialValue: selectedJenisKelamin,
//                     decoration: const InputDecoration(
//                       labelText: 'Jenis Kelamin',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: const [
//                       DropdownMenuItem(
//                         value: 'LAKI-LAKI',
//                         child: Text('Laki-laki'),
//                       ),
//                       DropdownMenuItem(
//                         value: 'PEREMPUAN',
//                         child: Text('Perempuan'),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       if (value != null) {
//                         setDialogState(() => selectedJenisKelamin = value);
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: umurController,
//                     decoration: const InputDecoration(
//                       labelText: 'Umur (tahun)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: tinggiController,
//                     decoration: const InputDecoration(
//                       labelText: 'Tinggi Badan (cm)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: beratController,
//                     decoration: const InputDecoration(
//                       labelText: 'Berat Badan (kg)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Get.back(),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final nama = namaController.text.trim();
//                   final nis = nisController.text.trim();
//                   final umur = int.tryParse(umurController.text.trim());
//                   final tinggi = double.tryParse(tinggiController.text.trim());
//                   final berat = double.tryParse(beratController.text.trim());

//                   if (nama.isEmpty || nis.isEmpty) {
//                     MBGLoaders.warningSnackBar(
//                       title: 'Peringatan',
//                       message: 'Nama dan NIS wajib diisi',
//                     );
//                     return;
//                   }

//                   if (selectedKelasId == null) {
//                     MBGLoaders.warningSnackBar(
//                       title: 'Peringatan',
//                       message: 'Harap memilih kelas siswa',
//                     );
//                     return;
//                   }

//                   if (umur == null || tinggi == null || berat == null) {
//                     MBGLoaders.warningSnackBar(
//                       title: 'Peringatan',
//                       message: 'Umur, tinggi, dan berat harus berupa angka',
//                     );
//                     return;
//                   }

//                   final success = await controller.createSiswa(
//                     kelasId: selectedKelasId!,
//                     nama: nama,
//                     nis: nis,
//                     umur: umur,
//                     jenisKelamin: selectedJenisKelamin,
//                     tinggiBadan: tinggi,
//                     beratBadan: berat,
//                     foto: selectedImage,
//                   );

//                   if (success && Get.isDialogOpen == true) {
//                     Get.back();
//                   }
//                 },
//                 child: const Text('Add'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
