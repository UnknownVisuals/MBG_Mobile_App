import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_pengiriman_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class DapurPengirimanAdd extends StatelessWidget {
  const DapurPengirimanAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurPengirimanController controller =
        Get.find<DapurPengirimanController>();

    // Form state with GetX
    final selectedSekolahId = Rx<String?>(null);

    String? validatePositiveInt(String? value, String fieldName) {
      final requiredValidation = MBGValidator.validateRequired(
        value,
        fieldName: fieldName,
      );
      if (requiredValidation != null) return requiredValidation;

      final parsed = int.tryParse(value!.trim());
      if (parsed == null || parsed <= 0) {
        return '$fieldName harus berupa angka lebih dari 0';
      }
      return null;
    }

    return Scaffold(
      appBar: const MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // Title
                Text(
                  'Tambah Pengiriman Baru',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Data Pengiriman Section
                const MBGSectionHeading(title: 'Data Pengiriman'),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Sekolah Dropdown
                Obx(() {
                  if (controller.isLoading.value &&
                      controller.sekolahList.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MBGColors.primary,
                      ),
                    );
                  }

                  final sekolahList = controller.sekolahList;

                  if (sekolahList.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(MBGSizes.md),
                      decoration: BoxDecoration(
                        border: Border.all(color: MBGColors.borderPrimary),
                        borderRadius: BorderRadius.circular(
                          MBGSizes.borderRadiusMd,
                        ),
                      ),
                      child: const Text(
                        'Tidak ada data sekolah tersedia',
                        style: TextStyle(color: MBGColors.textSecondary),
                      ),
                    );
                  }

                  // Set initial value if not set
                  if (selectedSekolahId.value == null) {
                    selectedSekolahId.value = sekolahList.first.id;
                  }

                  return DropdownButtonFormField<String>(
                    initialValue: selectedSekolahId.value,
                    items: sekolahList.map((sekolah) {
                      return DropdownMenuItem<String>(
                        value: sekolah.id,
                        child: Text(sekolah.nama!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedSekolahId.value = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Sekolah',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.building_3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan pilih sekolah';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Jumlah Tray
                TextFormField(
                  controller: controller.jumlahTrayController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Tray',
                    prefixIcon: Icon(Iconsax.box),
                  ),
                  validator: (value) =>
                      validatePositiveInt(value, 'Jumlah Tray'),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Jumlah Keranjang
                TextFormField(
                  controller: controller.jumlahKeranjangController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Keranjang',
                    prefixIcon: Icon(Iconsax.shopping_cart),
                  ),
                  validator: (value) =>
                      validatePositiveInt(value, 'Jumlah Keranjang'),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () async {
                              if (controller.formKey.currentState!.validate()) {
                                final payload = {
                                  'sekolahId': selectedSekolahId.value,
                                  'jumlahTray': int.parse(
                                    controller.jumlahTrayController.text,
                                  ),
                                  'jumlahKeranjang': int.parse(
                                    controller.jumlahKeranjangController.text,
                                  ),
                                };

                                final result = await controller
                                    .createPengiriman(payload);
                                if (result != null) {
                                  Get.back();
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MBGColors.primary,
                      ),
                      child: controller.isSubmitting.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Simpan Pengiriman',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: MBGColors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
