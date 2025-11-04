import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/absensi_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:intl/intl.dart';
import 'widgets/absensi_stat_card_widget.dart';
import 'widgets/absensi_empty_state_widget.dart';
import 'widgets/absensi_class_list_widget.dart';
import 'widgets/absensi_attendance_view_widget.dart';

class AbsensiScreen extends GetView<AbsensiController> {
  const AbsensiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.kelasList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Header with Date Selector
            Container(
              padding: MBGSpacingStyles.homeScreenPadding,
              decoration: BoxDecoration(
                color: MBGColors.primary.withOpacity(0.05),
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attendance',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Record daily class attendance',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      // Date Selector
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _showDatePicker(context),
                            icon: const Icon(Iconsax.calendar),
                            label: Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(controller.selectedDate.value),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: MBGColors.primary),
                              foregroundColor: MBGColors.primary,
                            ),
                          ),
                          const SizedBox(width: MBGSizes.sm),
                          IconButton(
                            tooltip: 'Refresh data',
                            onPressed: () => controller.refreshAll(),
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Today's Summary
                  if (controller.selectedDate.value.day == DateTime.now().day &&
                      controller.selectedDate.value.month ==
                          DateTime.now().month &&
                      controller.selectedDate.value.year == DateTime.now().year)
                    Padding(
                      padding: const EdgeInsets.only(top: MBGSizes.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: AbsensiStatCardWidget(
                              label: 'Total Present',
                              value: controller.totalPresent.value.toString(),
                              icon: Iconsax.user_tick,
                              color: MBGColors.success,
                            ),
                          ),
                          const SizedBox(width: MBGSizes.sm),
                          Expanded(
                            child: AbsensiStatCardWidget(
                              label: 'Total Classes',
                              value: controller.totalClasses.value.toString(),
                              icon: Iconsax.buildings,
                              color: MBGColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: controller.kelasList.isEmpty
                  ? const AbsensiEmptyStateWidget()
                  : Row(
                      children: [
                        // Classes List
                        Expanded(
                          flex: 2,
                          child: AbsensiClassListWidget(controller: controller),
                        ),

                        // Attendance View
                        Expanded(
                          flex: 3,
                          child: AbsensiAttendanceViewWidget(
                            controller: controller,
                            onRecordAttendance: _showRecordAttendanceDialog,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      await controller.setSelectedDate(date);
    }
  }

  void _showRecordAttendanceDialog(
    BuildContext context,
    AbsensiController controller,
    SekolahKelasModel kelas,
  ) {
    final formKey = GlobalKey<FormState>();
    final jumlahHadirController = TextEditingController();
    DateTime selectedDate = controller.selectedDate.value;

    // Check if attendance already exists for this date
    final existingAttendance = controller.getAttendanceForDate(selectedDate);
    if (existingAttendance != null) {
      jumlahHadirController.text = existingAttendance.jumlahHadir.toString();
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Record Attendance - ${kelas.nama}'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Selector
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Attendance Date'),
                    leading: const Icon(Iconsax.calendar),
                    trailing: const Icon(Iconsax.edit),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 30),
                        ),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                          // Check if attendance exists for new date
                          final existing = controller.getAttendanceForDate(
                            date,
                          );
                          if (existing != null) {
                            jumlahHadirController.text = existing.jumlahHadir
                                .toString();
                          } else {
                            jumlahHadirController.clear();
                          }
                        });
                      }
                    },
                  ),

                  const SizedBox(height: MBGSizes.spaceBtwItems),

                  // Total Students Info
                  Container(
                    padding: const EdgeInsets.all(MBGSizes.sm),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(
                        MBGSizes.borderRadiusSm,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.profile_2user, color: Colors.blue[700]),
                        const SizedBox(width: MBGSizes.sm),
                        Text(
                          'Total Students: ${kelas.jumlahSiswa ?? 0}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: MBGSizes.spaceBtwInputFields),

                  // Number of Students Present
                  TextFormField(
                    controller: jumlahHadirController,
                    decoration: const InputDecoration(
                      labelText: 'Students Present',
                      prefixIcon: Icon(Iconsax.user_tick),
                      hintText: 'Enter number of students present',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of students';
                      }
                      final number = int.tryParse(value);
                      if (number == null) {
                        return 'Please enter a valid number';
                      }
                      if (number < 0) {
                        return 'Number cannot be negative';
                      }
                      if (number > (kelas.jumlahSiswa ?? 0)) {
                        return 'Cannot exceed total students';
                      }
                      return null;
                    },
                  ),

                  if (existingAttendance != null)
                    Padding(
                      padding: const EdgeInsets.only(top: MBGSizes.sm),
                      child: Container(
                        padding: const EdgeInsets.all(MBGSizes.sm),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(
                            MBGSizes.borderRadiusSm,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              size: 16,
                              color: Colors.orange[700],
                            ),
                            const SizedBox(width: MBGSizes.xs),
                            Expanded(
                              child: Text(
                                'Attendance already exists for this date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final success = await controller.createAbsensi(
                    kelasId: kelas.id,
                    tanggal: selectedDate,
                    jumlahHadir: int.parse(jumlahHadirController.text),
                  );
                  if (success && context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MBGColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
