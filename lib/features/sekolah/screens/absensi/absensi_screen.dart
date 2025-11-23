import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

// Widgets
import 'widgets/absensi_stat_card_widget.dart';
import 'widgets/absensi_class_list_widget.dart';
import 'widgets/absensi_attendance_view_widget.dart';
import 'widgets/absensi_empty_state_widget.dart';
import 'widgets/select_class_prompt_widget.dart';

class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key});

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  DateTime selectedDate = DateTime.now();
  Map<String, dynamic>? selectedKelas;

  final List<Map<String, dynamic>> kelasList = [
    {'nama': '1A', 'jumlahSiswa': 25},
    {'nama': '2B', 'jumlahSiswa': 28},
    {'nama': '3C', 'jumlahSiswa': 30},
  ];

  int totalHadir = 60;
  int totalKelas = 3;

  @override
  void initState() {
    super.initState();
    selectedKelas = kelasList.isNotEmpty ? kelasList.first : null;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        final theme = Theme.of(context);
        final color = theme.colorScheme;

        return Theme(
          data: theme.copyWith(
            colorScheme: color.copyWith(
              primary: MBGColors.primary,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: color.surface,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final tanggalFormatted =
        DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(selectedDate);

    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Absensi Sekolah',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color.onSurface,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _pickDate,
            icon: Icon(
              Iconsax.calendar,
              size: 18,
              color: color.primary,
            ),
            label: Text(
              DateFormat('dd MMM yyyy', 'id_ID').format(selectedDate),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: MBGSizes.md),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(MBGSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Tanggal
            Text(
              tanggalFormatted,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: MBGSizes.md),

            /// Statistik Ringkas
            Row(
              children: [
                Expanded(
                  child: AbsensiStatCardWidget(
                    label: 'Total Hadir',
                    value: totalHadir.toString(),
                    icon: Iconsax.user_tick,
                    color: MBGColors.success,
                  ),
                ),
                const SizedBox(width: MBGSizes.sm),
                Expanded(
                  child: AbsensiStatCardWidget(
                    label: 'Total Kelas',
                    value: totalKelas.toString(),
                    icon: Iconsax.buildings,
                    color: MBGColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.md),

            /// Kontainer Utama
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (theme.brightness == Brightness.light)
                      BoxShadow(
                        color: color.shadow.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(MBGSizes.md),
                  child: Builder(
                    builder: (context) {
                      if (kelasList.isEmpty) {
                        return const AbsensiEmptyStateWidget();
                      }

                      if (selectedKelas == null) {
                        return const SelectClassPromptWidget();
                      }

                      /// Mobile Layout
                      if (isMobile) {
                        return Column(
                          children: [
                            AbsensiClassListWidget(
                              kelasList: kelasList,
                              selectedKelas: selectedKelas!,
                              onKelasTap: (kelas) {
                                setState(() => selectedKelas = kelas);
                              },
                            ),
                            const SizedBox(height: MBGSizes.md),
                            Expanded(
                              child: AbsensiAttendanceViewWidget(
                                selectedKelas: selectedKelas!,
                                selectedDate: selectedDate,
                              ),
                            ),
                          ],
                        );
                      }

                      /// Tablet / Desktop Layout
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AbsensiClassListWidget(
                              kelasList: kelasList,
                              selectedKelas: selectedKelas!,
                              onKelasTap: (kelas) {
                                setState(() => selectedKelas = kelas);
                              },
                            ),
                          ),
                          const SizedBox(width: MBGSizes.md),
                          Expanded(
                            flex: 3,
                            child: AbsensiAttendanceViewWidget(
                              selectedKelas: selectedKelas!,
                              selectedDate: selectedDate,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
