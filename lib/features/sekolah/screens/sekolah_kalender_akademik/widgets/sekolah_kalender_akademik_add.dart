import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kalender_akademik_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class SekolahKalenderAkademikAdd extends StatelessWidget {
  const SekolahKalenderAkademikAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SekolahKalenderAkademikController>();
    final formKey = GlobalKey<FormState>();
    final deskripsiController = TextEditingController();
    final tanggalMulaiController = TextEditingController();
    final tanggalSelesaiController = TextEditingController();

    DateTime? selectedStartDate;
    DateTime? selectedEndDate;

    Future<void> pickDate(
      BuildContext context,
      TextEditingController controller,
      bool isStart,
    ) async {
      final initialDate = isStart
          ? (selectedStartDate ?? DateTime.now())
          : (selectedEndDate ?? selectedStartDate ?? DateTime.now());
      final firstDate = isStart
          ? DateTime(2000)
          : (selectedStartDate ?? DateTime(2000));

      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: DateTime(2100),
      );

      if (picked != null) {
        if (isStart) {
          selectedStartDate = picked;
          // Reset end date if it's before new start date
          if (selectedEndDate != null && selectedEndDate!.isBefore(picked)) {
            selectedEndDate = null;
            tanggalSelesaiController.clear();
          }
        } else {
          selectedEndDate = picked;
        }
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    return Scaffold(
      appBar: const MBGAppBar(
        showBackArrow: true,
        title: Text('Tambah Event Kalender'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Tambah Event',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                const MBGSectionHeading(title: 'Detail Event'),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Deskripsi
                TextFormField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Event',
                    prefixIcon: Icon(Iconsax.note),
                  ),
                  validator: (value) => MBGValidator.validateRequired(
                    value,
                    fieldName: 'Deskripsi',
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Tanggal Mulai
                TextFormField(
                  controller: tanggalMulaiController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Mulai',
                    prefixIcon: Icon(Iconsax.calendar_1),
                  ),
                  onTap: () => pickDate(context, tanggalMulaiController, true),
                  validator: (value) => MBGValidator.validateRequired(
                    value,
                    fieldName: 'Tanggal Mulai',
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Tanggal Selesai
                TextFormField(
                  controller: tanggalSelesaiController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Selesai (Opsional)',
                    prefixIcon: Icon(Iconsax.calendar_tick),
                    hintText: 'Sama dengan tanggal mulai jika kosong',
                  ),
                  onTap: () =>
                      pickDate(context, tanggalSelesaiController, false),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            final payload = {
              'deskripsi': deskripsiController.text.trim(),
              'tanggalMulai': tanggalMulaiController.text,
              'tanggalSelesai': tanggalSelesaiController.text.isNotEmpty
                  ? tanggalSelesaiController.text
                  : tanggalMulaiController.text,
            };

            controller.createEvent(payload);
          },
          child: const Text('Simpan Event'),
        ),
      ),
    );
  }
}
