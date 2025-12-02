import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_harian_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';

/// Full screen mock for creating a daily menu entry.
class DapurMenuHarianAdd extends StatelessWidget {
  const DapurMenuHarianAdd({
    super.key,
    required this.menuPlanningId,
    required this.startDate,
    required this.endDate,
  });

  final String menuPlanningId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    final DapurMenuHarianController controller =
        Get.find<DapurMenuHarianController>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final dateController = TextEditingController();
    final nameController = TextEditingController();
    final costController = TextEditingController();
    final targetTrayController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    // State variables
    final selectedDate = Rx<DateTime?>(null);
    final selectedStartTime = Rx<TimeOfDay?>(null);
    final selectedEndTime = Rx<TimeOfDay?>(null);

    // Helper functions
    Future<void> selectDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            selectedDate.value ??
            (DateTime.now().isAfter(startDate) &&
                    DateTime.now().isBefore(endDate)
                ? DateTime.now()
                : startDate),
        firstDate: startDate,
        lastDate: endDate,
      );
      if (picked != null) {
        selectedDate.value = picked;
        // Format: YYYY-MM-DD
        dateController.text = picked.toIso8601String().split('T')[0];
      }
    }

    Future<void> selectStartTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedStartTime.value ?? TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (picked != null) {
        selectedStartTime.value = picked;
        // Format: HH:mm
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        startTimeController.text = '$hour:$minute';
      }
    }

    Future<void> selectEndTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedEndTime.value ?? TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (picked != null) {
        selectedEndTime.value = picked;
        // Format: HH:mm
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        endTimeController.text = '$hour:$minute';
      }
    }

    return Scaffold(
      appBar: const MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Form Tambah Menu Harian',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: selectDate,
                decoration: const InputDecoration(
                  labelText: 'Tanggal (YYYY-MM-DD)',
                  prefixIcon: Icon(Iconsax.calendar_1),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Tanggal wajib diisi'
                    : null,
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                  prefixIcon: Icon(Iconsax.note_2),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama menu wajib diisi'
                    : null,
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: costController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Biaya per Tray (Rp)',
                        prefixIcon: Icon(Iconsax.money),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Biaya wajib diisi'
                          : null,
                    ),
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  Expanded(
                    child: TextFormField(
                      controller: targetTrayController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Target Tray',
                        prefixIcon: Icon(Iconsax.box),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Target tray wajib diisi'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: startTimeController,
                      readOnly: true,
                      onTap: selectStartTime,
                      decoration: const InputDecoration(
                        labelText: 'Jam Mulai Masak',
                        prefixIcon: Icon(Iconsax.clock),
                        hintText: 'HH:mm',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Jam mulai wajib diisi'
                          : null,
                    ),
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  Expanded(
                    child: TextFormField(
                      controller: endTimeController,
                      readOnly: true,
                      onTap: selectEndTime,
                      decoration: const InputDecoration(
                        labelText: 'Jam Selesai Masak',
                        prefixIcon: Icon(Iconsax.clock_1),
                        hintText: 'HH:mm',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Jam selesai wajib diisi'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: caloriesController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Kalori (kcal)',
                        prefixIcon: Icon(Iconsax.activity),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Kalori wajib diisi'
                          : null,
                    ),
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  Expanded(
                    child: TextFormField(
                      controller: proteinController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Protein (g)',
                        prefixIcon: Icon(Iconsax.security_user),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Protein wajib diisi'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: carbsController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Karbohidrat (g)',
                        prefixIcon: Icon(Iconsax.bezier),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Karbohidrat wajib diisi'
                          : null,
                    ),
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  Expanded(
                    child: TextFormField(
                      controller: fatController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Lemak (g)',
                        prefixIcon: Icon(Iconsax.chart_21),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Lemak wajib diisi'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.md),
          child: ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                MBGLoadingOverlay.show();
                await controller.createMenuHarian(
                  planningId: menuPlanningId,
                  payload: {
                    "tanggal": dateController.text,
                    "namaMenu": nameController.text,
                    "biayaPerTray": double.parse(costController.text),
                    "jamMulaiMasak": startTimeController.text,
                    "jamSelesaiMasak": endTimeController.text,
                    "kalori": double.parse(caloriesController.text),
                    "protein": double.parse(proteinController.text),
                    "karbohidrat": double.parse(carbsController.text),
                    "lemak": double.parse(fatController.text),
                    "targetTray": int.parse(targetTrayController.text),
                  },
                );
                MBGLoadingOverlay.hide();
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MBGColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Simpan Menu'),
          ),
        ),
      ),
    );
  }
}
