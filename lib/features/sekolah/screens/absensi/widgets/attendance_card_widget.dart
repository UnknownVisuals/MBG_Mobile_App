import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/sekolah_absensi_model.dart';
import '../../../models/sekolah_kelas_model.dart';

/// Attendance card widget (theme-adaptive)
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final attendanceRate =
        (absensi.jumlahHadir / (kelas.jumlahSiswa ?? 1) * 100).toInt();

    // Progress bar color
    final Color progressColor = attendanceRate >= 80
        ? MBGColors.success
        : attendanceRate >= 60
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: MBGSizes.md),
      color: colors.surface,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.md),
        child: Row(
          children: [
            // DATE BADGE
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  MBGColors.primary.withOpacity(0.12),
                  colors.surface, // adaptif
                ),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd').format(absensi.tanggal),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MBGColors.primary,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(absensi.tanggal),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: MBGColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: MBGSizes.md),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FULL DATE
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(absensi.tanggal),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: MBGSizes.xs),

                  Row(
                    children: [
                      Icon(
                        Iconsax.user_tick,
                        size: 16,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: MBGSizes.xs),
                      Text(
                        '${absensi.jumlahHadir} / ${kelas.jumlahSiswa ?? 0} students present',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: MBGSizes.sm),

                  // PROGRESS BAR
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(MBGSizes.borderRadiusSm),
                          child: LinearProgressIndicator(
                            value: attendanceRate / 100,
                            minHeight: 8,
                            backgroundColor: colors.surfaceVariant,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(progressColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: MBGSizes.sm),
                      Text(
                        '$attendanceRate%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: progressColor,
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
