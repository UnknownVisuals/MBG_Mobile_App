import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/absensi_controller.dart';

/// Classes list widget for absensi screen
class AbsensiClassListWidget extends StatelessWidget {
  final AbsensiController controller;

  const AbsensiClassListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
}
