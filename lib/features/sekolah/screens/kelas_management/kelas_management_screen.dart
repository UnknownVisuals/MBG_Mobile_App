import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// UI Only - Sekolah: Manajemen Kelas Screen (Stateless)
class KelasManagementScreen extends StatelessWidget {
  const KelasManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data agar UI bisa tampil
    final List<Map<String, dynamic>> kelasList = [
      {'nama': '1A', 'tingkat': 1},
      {'nama': '2B', 'tingkat': 2},
      {'nama': '3C', 'tingkat': 3},
      {'nama': '4D', 'tingkat': 4},
      {'nama': '5E', 'tingkat': 5},
    ];

    return Scaffold(
      appBar: const MBGAppBar(
        title: Text('Manajemen Kelas'),
        showBackArrow: false,
      ),
      body: kelasList.isEmpty
          ? _buildEmptyState(context)
          : GridView.builder(
              padding: const EdgeInsets.all(MBGSizes.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: MBGSizes.md,
                mainAxisSpacing: MBGSizes.md,
                childAspectRatio: 1.2,
              ),
              itemCount: kelasList.length,
              itemBuilder: (context, index) {
                final kelas = kelasList[index];
                final color = _tingkatColor(kelas['tingkat']);

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit ${kelas['nama']}')),
                      );
                    },
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
                        padding: const EdgeInsets.all(MBGSizes.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    'Tingkat ${kelas['tingkat']}',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              kelas['nama'],
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
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tambah Kelas (dummy action)')),
          );
        },
        backgroundColor: MBGColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Empty state jika belum ada kelas
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada kelas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan kelas dengan tombol + di bawah',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Warna sesuai tingkat kelas
  Color _tingkatColor(int tingkat) {
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
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mbg_mobile_app/common/widgets/appbar.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_management_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
// import 'package:mbg_mobile_app/utils/popups/loaders.dart';

// class KelasManagementScreen extends GetView<SekolahKelasManagementController> {
//   const KelasManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MBGAppBar(
//         title: const Text('Manajemen Kelas'),
//         showBackArrow: false,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final kelasList = controller.kelasList;
//         if (kelasList.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.class_outlined, size: 80, color: Colors.grey[400]),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Belum ada kelas',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Tambahkan kelas dengan tombol + di bawah',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
//                 ),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: controller.refreshKelas,
//           child: GridView.builder(
//             padding: const EdgeInsets.all(16),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 1.3,
//             ),
//             itemCount: kelasList.length,
//             itemBuilder: (context, index) {
//               final kelas = kelasList[index];
//               final color = _tingkatColor(kelas.tingkat);

//               return Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(12),
//                   onTap: () => _showEditKelasDialog(context, kelas),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       gradient: LinearGradient(
//                         colors: [
//                           color.withOpacity(0.7),
//                           color.withOpacity(0.3),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 6,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.9),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   'Tingkat ${kelas.tingkat}',
//                                   style: TextStyle(
//                                     color: color,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: const Icon(
//                                   Icons.delete,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: () => controller.deleteKelas(kelas),
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                               ),
//                             ],
//                           ),
//                           const Spacer(),
//                           Text(
//                             kelas.nama,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               shadows: [
//                                 Shadow(
//                                   offset: Offset(1, 1),
//                                   blurRadius: 3,
//                                   color: Colors.black26,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddKelasDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Color _tingkatColor(int tingkat) {
//     final colors = [
//       Colors.red,
//       Colors.orange,
//       Colors.yellow.shade700,
//       Colors.green,
//       Colors.blue,
//       Colors.purple,
//     ];
//     return colors[(tingkat - 1) % colors.length];
//   }

//   Future<void> _showAddKelasDialog(BuildContext context) async {
//     final namaController = TextEditingController();
//     final tingkatController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Tambah Kelas'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: namaController,
//               decoration: const InputDecoration(
//                 labelText: 'Nama Kelas (contoh: 1A, 2B)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: tingkatController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Tingkat (1-6)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final tingkat = int.tryParse(tingkatController.text);
//               if (namaController.text.isEmpty || tingkat == null) {
//                 MBGLoaders.warningSnackBar(
//                   title: 'Peringatan',
//                   message: 'Nama dan tingkat wajib diisi',
//                 );
//                 return;
//               }

//               if (tingkat < 1 || tingkat > 6) {
//                 MBGLoaders.warningSnackBar(
//                   title: 'Peringatan',
//                   message: 'Tingkat harus antara 1-6',
//                 );
//                 return;
//               }

//               Navigator.pop(context);
//               await controller.createKelas(
//                 nama: namaController.text,
//                 tingkat: tingkat,
//               );
//             },
//             child: const Text('Simpan'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _showEditKelasDialog(
//     BuildContext context,
//     SekolahKelasModel kelas,
//   ) async {
//     final namaController = TextEditingController(text: kelas.nama);
//     final tingkatController = TextEditingController(
//       text: kelas.tingkat.toString(),
//     );

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Kelas'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: namaController,
//               decoration: const InputDecoration(
//                 labelText: 'Nama Kelas',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: tingkatController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Tingkat (1-6)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final tingkat = int.tryParse(tingkatController.text);
//               if (namaController.text.isEmpty || tingkat == null) {
//                 MBGLoaders.warningSnackBar(
//                   title: 'Peringatan',
//                   message: 'Nama dan tingkat wajib diisi',
//                 );
//                 return;
//               }

//               if (tingkat < 1 || tingkat > 6) {
//                 MBGLoaders.warningSnackBar(
//                   title: 'Peringatan',
//                   message: 'Tingkat harus antara 1-6',
//                 );
//                 return;
//               }

//               Navigator.pop(context);
//               await controller.updateKelas(
//                 id: kelas.id,
//                 nama: namaController.text,
//                 tingkat: tingkat,
//               );
//             },
//             child: const Text('Simpan'),
//           ),
//         ],
//       ),
//     );
//   }
// }
