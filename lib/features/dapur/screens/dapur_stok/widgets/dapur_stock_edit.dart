import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_stock_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stock_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_stok/widgets/dapur_stock_adjust.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class DapurStokEdit extends StatelessWidget {
  const DapurStokEdit({super.key, required this.stok});

  final DapurStokModel stok;

  @override
  Widget build(BuildContext context) {
    // Dependencies
    final DapurStokController dapurStokController =
        Get.find<DapurStokController>();

    // Input Controllers with initial values
    final TextEditingController namaController = TextEditingController(
      text: stok.nama,
    );
    final Rx<KategoriStok> selectedCategory = stok.kategori.obs;
    final TextEditingController stokController = TextEditingController(
      text: stok.stokKg.toString(),
    );

    // Form key
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Title
                Text(
                  'Form Perbarui Stok',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Form Fields
                MBGSectionHeading(title: 'Informasi Bahan'),
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Nama Bahan
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Bahan',
                    prefixIcon: Icon(Iconsax.shopping_bag),
                  ),
                  validator: (value) {
                    return MBGValidator.validateRequired(
                      value,
                      fieldName: 'Nama Bahan',
                    );
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Kategori
                Obx(
                  () => DropdownButtonFormField<KategoriStok>(
                    initialValue: selectedCategory.value,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      prefixIcon: Icon(Iconsax.tag),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return KategoriStok.values.map((kategori) {
                        return Text(kategori.label);
                      }).toList();
                    },
                    items: KategoriStok.values.map((kategori) {
                      return DropdownMenuItem(
                        value: kategori,
                        child: Row(
                          children: [
                            Icon(
                              dapurStokController.getCategoryIcon(kategori),
                              color: dapurStokController.getCategoryColor(
                                kategori,
                              ),
                              size: MBGSizes.iconMd,
                            ),
                            const SizedBox(width: MBGSizes.spaceBtwItems),
                            Text(kategori.label),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedCategory.value = value;
                      }
                    },
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Jumlah Stok
                TextFormField(
                  controller: stokController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Stok (kg)',
                    prefixIcon: Icon(Iconsax.chart),
                    suffixText: 'kg',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah stok harus diisi';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Jumlah stok harus berupa angka';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Jumlah stok harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),

                // Info Text
                Text(
                  'Gunakan tombol "Sesuaikan Stok" untuk menambah atau mengurangi stok berdasarkan mutasi aktual.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MBGColors.textSecondary,
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await dapurStokController.updateStok(
                          stokId: stok.id,
                          nama: namaController.text,
                          kategori: selectedCategory.value,
                          stokKg: double.parse(stokController.text),
                        );
                      }
                    },
                    child: const Text('Simpan Perubahan'),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.dialog(DapurStockAdjust(stok: stok));
                    },
                    child: const Text('Sesuaikan Stok'),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
