import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class AbsensiAttendanceViewWidget extends StatelessWidget {
  final Map<String, dynamic> selectedKelas;
  final DateTime? selectedDate;

  const AbsensiAttendanceViewWidget({
    super.key,
    required this.selectedKelas,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy data histori absensi
    final absensiHistory = [
      {'tanggal': '1 November 2025', 'hadir': 23},
      {'tanggal': '2 November 2025', 'hadir': 25},
      {'tanggal': '3 November 2025', 'hadir': 24},
    ];

    final tanggalAktif = selectedDate != null
        ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
        : "Tidak ada tanggal dipilih";

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: MBGColors.primary.withOpacity(0.05),
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelas ${selectedKelas['nama']}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Tanggal: $tanggalAktif',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.add, size: 18),
                  label: const Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MBGColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Daftar histori absensi
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(MBGSizes.md),
              itemCount: absensiHistory.length,
              itemBuilder: (context, index) {
                final record = absensiHistory[index];
                final tanggal = record['tanggal'];
                final hadir = record['hadir'] ?? 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: MBGSizes.sm),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Iconsax.calendar),
                    title: Text(tanggal.toString()),
                    subtitle: Text('Jumlah hadir: $hadir siswa'),
                    trailing: const Icon(
                      Iconsax.tick_circle,
                      color: MBGColors.success,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../../../utils/constants/colors.dart';
// import '../../../../../utils/constants/sizes.dart';
// import '../../../controllers/absensi_controller.dart';
// import '../../../models/sekolah_kelas_model.dart';
// import '../widgets/select_class_prompt_widget.dart';
// import '../widgets/empty_attendance_history_widget.dart';
// import '../widgets/attendance_card_widget.dart';

// /// Attendance view widget with record button and history
// class AbsensiAttendanceViewWidget extends StatelessWidget {
//   final AbsensiController controller;
//   final Function(BuildContext, AbsensiController, SekolahKelasModel)
//   onRecordAttendance;

//   const AbsensiAttendanceViewWidget({
//     super.key,
//     required this.controller,
//     required this.onRecordAttendance,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.selectedKelas.value == null) {
//         return const SelectClassPromptWidget();
//       }

//       if (controller.isLoadingHistory.value &&
//           controller.absensiHistory.isEmpty) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       return Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.all(MBGSizes.md),
//             decoration: BoxDecoration(
//               color: MBGColors.primary.withOpacity(0.05),
//               border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Class ${controller.selectedKelas.value!.nama}',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         '${controller.absensiHistory.length} attendance records',
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                     ],
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () => onRecordAttendance(
//                     context,
//                     controller,
//                     controller.selectedKelas.value!,
//                   ),
//                   icon: const Icon(Iconsax.add, size: 18),
//                   label: const Text('Record'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: MBGColors.primary,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Attendance History
//           Expanded(
//             child: controller.absensiHistory.isEmpty
//                 ? const EmptyAttendanceHistoryWidget()
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(MBGSizes.md),
//                     itemCount: controller.absensiHistory.length,
//                     itemBuilder: (context, index) {
//                       final absensi = controller.absensiHistory[index];
//                       return AttendanceCardWidget(
//                         absensi: absensi,
//                         kelas: controller.selectedKelas.value!,
//                       );
//                     },
//                   ),
//           ),
//         ],
//       );
//     });
//   }
// }
