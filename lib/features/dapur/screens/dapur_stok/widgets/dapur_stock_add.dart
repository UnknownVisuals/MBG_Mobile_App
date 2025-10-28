import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_stock_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stok_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class DapurStockAdd extends StatefulWidget {
  const DapurStockAdd({super.key});

  @override
  State<DapurStockAdd> createState() => _DapurStockAddState();
}

class _DapurStockAddState extends State<DapurStockAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _stokKgController;
  late final DapurStockController _stockController;
  late KategoriStok _selectedCategory;

  @override
  void initState() {
    super.initState();
    _stockController = Get.find<DapurStockController>();
    _namaController = TextEditingController();
    _stokKgController = TextEditingController();
    _selectedCategory = _stockController.kategoriOptions.first;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokKgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryOptions = _stockController.kategoriOptions;

    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Tambah Stok',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                MBGSectionHeading(title: 'Informasi Bahan'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Bahan',
                    prefixIcon: Icon(Iconsax.shopping_bag),
                  ),
                  validator: (value) => MBGValidator.validateRequired(
                    value,
                    fieldName: 'Nama bahan',
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                DropdownButtonFormField<KategoriStok>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: Icon(Iconsax.tag),
                  ),
                  items: categoryOptions
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: _stokKgController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Stok (kg)',
                    prefixIcon: Icon(Iconsax.chart),
                    suffixText: 'kg',
                  ),
                  validator: (value) {
                    final validation = MBGValidator.validateRequired(
                      value,
                      fieldName: 'Jumlah stok',
                    );
                    if (validation != null) return validation;
                    final parsed = double.tryParse(value!);
                    if (parsed == null || parsed <= 0) {
                      return 'Jumlah stok harus berupa angka lebih dari 0';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                Text(
                  'Pastikan data stok sesuai dengan kondisi terakhir di dapur.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MBGColors.textSecondary,
                  ),
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _stockController.isSaving.value
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) return;

                              final stokKg = double.tryParse(
                                _stokKgController.text.trim(),
                              );
                              if (stokKg == null) {
                                MBGLoaders.errorSnackBar(
                                  title: 'Nilai tidak valid',
                                  message: 'Masukkan angka stok yang benar.',
                                );
                                return;
                              }

                              await _stockController.addStok(
                                nama: _namaController.text.trim(),
                                kategori: _selectedCategory,
                                stokKg: stokKg,
                              );
                            },
                      child: _stockController.isSaving.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Tambah Stok'),
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
