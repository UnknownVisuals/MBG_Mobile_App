import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/sekolah_absensi_model.dart';
import '../../../models/sekolah_kelas_model.dart';

/// Attendance card widget for displaying attendance records
class AttendanceCardWidget extends StatelessWidget {
  final SekolahAbsensiModel absensi;
  final SekolahKelasModel kelas;

  const AttendanceCardWidget({
    super.key,
    required this.absensi,
    required this.kelas,
  });

  @override
  Widget build(BuildContext context) {
    final attendanceRate =
        (absensi.jumlahHadir / (kelas.jumlahSiswa ?? 1) * 100).toInt();

    return Card(
      margin: const EdgeInsets.only(bottom: MBGSizes.md),
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.md),
        child: Row(
          children: [
            // Date Badge
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: MBGColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd').format(absensi.tanggal),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MBGColors.primary,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(absensi.tanggal),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: MBGColors.primary),
                  ),
                ],
              ),
            ),

            const SizedBox(width: MBGSizes.md),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(absensi.tanggal),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: MBGSizes.xs),
                  Row(
                    children: [
                      Icon(
                        Iconsax.user_tick,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: MBGSizes.xs),
                      Text(
                        '${absensi.jumlahHadir} / ${kelas.jumlahSiswa ?? 0} students present',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: MBGSizes.sm),
                  // Attendance Rate Bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            MBGSizes.borderRadiusSm,
                          ),
                          child: LinearProgressIndicator(
                            value: attendanceRate / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              attendanceRate >= 80
                                  ? MBGColors.success
                                  : attendanceRate >= 60
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: MBGSizes.sm),
                      Text(
                        '$attendanceRate%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: attendanceRate >= 80
                              ? MBGColors.success
                              : attendanceRate >= 60
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
