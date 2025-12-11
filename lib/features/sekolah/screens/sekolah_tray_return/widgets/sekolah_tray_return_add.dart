import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_tray_return_controller.dart';

import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class SekolahTrayReturnAdd extends StatelessWidget {
  const SekolahTrayReturnAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final SekolahTrayReturnController controller =
        Get.find<SekolahTrayReturnController>();

    // Ensure data is loaded
    // controller.fetchCompletedPengiriman(); // Called before navigation

    return Scaffold(
      appBar: const MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        padding: MBGSpacingStyles.homeScreenPadding,
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MBGSectionHeading(title: 'Form Pengembalian Tray'),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              Obx(() {
                if (controller.isLoading.value &&
                    controller.completedPengirimanList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.completedPengirimanList.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(MBGSizes.md),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: MBGColors.borderPrimary),
                      borderRadius: BorderRadius.circular(
                        MBGSizes.borderRadiusMd,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Iconsax.box_remove,
                          size: 40,
                          color: MBGColors.textSecondary,
                        ),
                        const SizedBox(height: MBGSizes.sm),
                        const Text(
                          'Tidak ada pengiriman selesai yang dapat dikembalikan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: MBGColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return DropdownButtonFormField<String>(
                  initialValue: controller.selectedPengirimanId.value,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Pengiriman',
                    prefixIcon: Icon(Iconsax.box),
                    border: OutlineInputBorder(),
                  ),
                  items: controller.completedPengirimanList.map((delivery) {
                    final date = MBGHelperFunctions.getFormattedDate(
                      delivery.waktuSampai ?? delivery.updatedAt,
                    );
                    final label =
                        '$date - ${delivery.jumlahTray} Tray, ${delivery.jumlahKeranjang} Keranjang';
                    return DropdownMenuItem(
                      value: delivery.id,
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedPengirimanId.value = value;
                  },
                  validator: (value) => MBGValidator.validateRequired(
                    value,
                    fieldName: 'Pengiriman',
                  ),
                  isExpanded: true,
                );
              }),

              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              TextFormField(
                controller: controller.keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan (Opsional)',
                  hintText: 'Contoh: Ada 2 tray rusak',
                  prefixIcon: Icon(Iconsax.note_text),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: MBGSizes.spaceBtwSections),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () {
                            controller.createTrayReturn();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MBGColors.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: MBGSizes.md,
                      ),
                    ),
                    child: Text(
                      controller.isSubmitting.value
                          ? 'Memproses...'
                          : 'Buat Pengembalian',
                      style: const TextStyle(color: MBGColors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
