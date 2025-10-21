import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/absensi_controller.dart';
import '../../../models/kelas_model.dart';
import '../widgets/select_class_prompt_widget.dart';
import '../widgets/empty_attendance_history_widget.dart';
import '../widgets/attendance_card_widget.dart';

/// Attendance view widget with record button and history
class AbsensiAttendanceViewWidget extends StatelessWidget {
  final AbsensiController controller;
  final Function(BuildContext, AbsensiController, KelasModel)
  onRecordAttendance;

  const AbsensiAttendanceViewWidget({
    super.key,
    required this.controller,
    required this.onRecordAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedKelas.value == null) {
        return const SelectClassPromptWidget();
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
                  onPressed: () => onRecordAttendance(
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
                ? const EmptyAttendanceHistoryWidget()
                : ListView.builder(
                    padding: const EdgeInsets.all(MBGSizes.md),
                    itemCount: controller.absensiHistory.length,
                    itemBuilder: (context, index) {
                      final absensi = controller.absensiHistory[index];
                      return AttendanceCardWidget(
                        absensi: absensi,
                        kelas: controller.selectedKelas.value!,
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
