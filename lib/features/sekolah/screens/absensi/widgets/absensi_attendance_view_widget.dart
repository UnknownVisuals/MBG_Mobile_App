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
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    /// Dummy data
    final absensiHistory = [
      {'tanggal': '1 November 2025', 'hadir': 23},
      {'tanggal': '2 November 2025', 'hadir': 25},
      {'tanggal': '3 November 2025', 'hadir': 24},
    ];

    final tanggalAktif = selectedDate != null
        ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
        : "Tidak ada tanggal dipilih";

    return Container(
      color: colors.surface, // ADAPTIVE BACKGROUND
      child: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: colors.primaryContainer.withOpacity(0.4),
              border: Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withOpacity(0.4),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TITLE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelas ${selectedKelas['nama']}',
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      'Tanggal: $tanggalAktif',
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                // BUTTON "TAMBAH"
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Iconsax.add, size: 18, color: colors.onPrimary),
                  label: Text(
                    'Tambah',
                    style: text.labelLarge?.copyWith(
                      color: colors.onPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              ],
            ),
          ),

          // LIST HISTORI
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(MBGSizes.md),
              itemCount: absensiHistory.length,
              itemBuilder: (context, index) {
                final record = absensiHistory[index];
                final tanggal = record['tanggal'];
                final hadir = record['hadir'];

                return Card(
                  margin: const EdgeInsets.only(bottom: MBGSizes.sm),
                  color: colors.surfaceVariant,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Iconsax.calendar,
                      color: colors.primary,
                    ),
                    title: Text(
                      tanggal.toString(),
                      style: text.titleMedium?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Jumlah hadir: $hadir siswa',
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      Iconsax.tick_circle,
                      color: colors.secondary, // ADAPTIVE SUCCESS COLOR
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
