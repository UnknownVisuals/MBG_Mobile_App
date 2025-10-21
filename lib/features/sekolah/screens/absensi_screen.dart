import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/absensi_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/kelas_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

class AbsensiScreen extends StatelessWidget {
  const AbsensiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AbsensiController());
    final sekolahController = Get.find<SekolahController>();

    // Set classes from sekolah controller
    controller.setKelasList(sekolahController.classes);

    return Scaffold(
      body: Obx(() {
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
                      OutlinedButton.icon(
                        onPressed: () => _showDatePicker(context, controller),
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
                            child: _buildStatCard(
                              context,
                              'Total Present',
                              controller.totalPresent.value.toString(),
                              Iconsax.user_tick,
                              MBGColors.success,
                            ),
                          ),
                          const SizedBox(width: MBGSizes.sm),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Total Classes',
                              controller.totalClasses.value.toString(),
                              Iconsax.buildings,
                              MBGColors.primary,
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
                  ? _buildEmptyState(context)
                  : Row(
                      children: [
                        // Classes List
                        Expanded(
                          flex: 2,
                          child: _buildClassesList(context, controller),
                        ),

                        // Attendance View
                        Expanded(
                          flex: 3,
                          child: _buildAttendanceView(context, controller),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: MBGSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.buildings, size: 80, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'No Classes Available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Create classes to record attendance',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesList(BuildContext context, AbsensiController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(MBGSizes.md),
        itemCount: controller.kelasList.length,
        itemBuilder: (context, index) {
          final kelas = controller.kelasList[index];
          final isSelected = controller.selectedKelas.value?.id == kelas.id;
          final hasAttendance = controller.hasAttendanceForDate(
            controller.selectedDate.value,
          );

          return Obx(
            () => Card(
              elevation: isSelected ? 4 : 1,
              color: isSelected ? MBGColors.primary.withOpacity(0.1) : null,
              margin: const EdgeInsets.only(bottom: MBGSizes.sm),
              child: ListTile(
                onTap: () => controller.selectKelas(kelas),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MBGColors.primary
                        : MBGColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      kelas.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : MBGColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Class ${kelas.nama}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${kelas.jumlahSiswa ?? 0} students',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasAttendance && isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: MBGSizes.sm,
                          vertical: MBGSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: MBGColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            MBGSizes.borderRadiusSm,
                          ),
                        ),
                        child: Text(
                          'Recorded',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: MBGColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    const SizedBox(width: MBGSizes.sm),
                    Icon(
                      isSelected ? Iconsax.tick_circle5 : Iconsax.arrow_right_3,
                      color: isSelected ? MBGColors.primary : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttendanceView(
    BuildContext context,
    AbsensiController controller,
  ) {
    return Obx(() {
      if (controller.selectedKelas.value == null) {
        return _buildSelectClassPrompt(context);
      }

      if (controller.isLoadingHistory.value &&
          controller.absensiHistory.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class ${controller.selectedKelas.value!.nama}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${controller.absensiHistory.length} attendance records',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showRecordAttendanceDialog(
                    context,
                    controller,
                    controller.selectedKelas.value!,
                  ),
                  icon: const Icon(Iconsax.add, size: 18),
                  label: const Text('Record'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MBGColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Attendance History
          Expanded(
            child: controller.absensiHistory.isEmpty
                ? _buildEmptyHistory(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(MBGSizes.md),
                    itemCount: controller.absensiHistory.length,
                    itemBuilder: (context, index) {
                      final absensi = controller.absensiHistory[index];
                      return _buildAttendanceCard(
                        context,
                        absensi,
                        controller.selectedKelas.value!,
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildSelectClassPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.arrow_left, size: 60, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'Select a Class',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Choose a class to view or record attendance',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.note, size: 60, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'No Attendance Records',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Start recording daily attendance',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(
    BuildContext context,
    dynamic absensi,
    KelasModel kelas,
  ) {
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

  void _showDatePicker(
    BuildContext context,
    AbsensiController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      controller.setSelectedDate(date);
    }
  }

  void _showRecordAttendanceDialog(
    BuildContext context,
    AbsensiController controller,
    KelasModel kelas,
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
