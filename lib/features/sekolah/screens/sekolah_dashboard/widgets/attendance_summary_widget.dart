import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Attendance summary card widget (UI-only, tanpa controller)
class AttendanceSummaryWidget extends StatelessWidget {
  const AttendanceSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SekolahDashboardController>();

    return Obx(() {
      final totalSiswa = controller.totalSiswa;
      final totalKelas = controller.totalKelas;

      return Container(
        padding: const EdgeInsets.all(MBGSizes.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MBGColors.primary,
              MBGColors.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
          boxShadow: [
            BoxShadow(
              color: MBGColors.primary.withValues(alpha: 0.25),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔸 Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.user_tick,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Total Siswa",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 Statistik singkat
            Row(
              children: [
                Expanded(
                  child: _WhiteStatCard(
                    label: 'Total Siswa',
                    value: totalSiswa.toString(),
                    icon: Iconsax.user_tick,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _WhiteStatCard(
                    label: 'Total Kelas',
                    value: totalKelas.toString(),
                    icon: Iconsax.teacher,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

/// Kartu kecil putih di dalam AttendanceSummary
class _WhiteStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _WhiteStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
