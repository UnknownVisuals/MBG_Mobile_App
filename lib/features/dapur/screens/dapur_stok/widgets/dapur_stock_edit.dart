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

class DapurStockEdit extends StatefulWidget {
  const DapurStockEdit({super.key, required this.stok});

  final StokModel stok;

  @override
  State<DapurStockEdit> createState() => _DapurStockEditState();
}

class _DapurStockEditState extends State<DapurStockEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _stokKgController;
  late final DapurStockController _stockController;
  late KategoriStok _selectedCategory;

  @override
  void initState() {
    super.initState();
    _stockController = Get.find<DapurStockController>();
    _namaController = TextEditingController(text: widget.stok.nama);
    _stokKgController = TextEditingController(
      text: widget.stok.stokKg.toString(),
    );
    _selectedCategory = widget.stok.kategori;
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
                  'Form Perbarui Stok',
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
                    if (parsed == null || parsed < 0) {
                      return 'Jumlah stok harus berupa angka 0 atau lebih';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),
                Text(
                  'Gunakan tombol "Sesuaikan Stok" untuk menambah atau mengurangi stok berdasarkan mutasi aktual.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MBGColors.textSecondary,
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),

                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: _stockController.isSaving.value
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

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

                              await _stockController.updateStok(
                                stokId: widget.stok.id,
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
                          : const Text('Simpan Perubahan'),
                    ),
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showAdjustDialog(context),
                    child: const Text('Sesuaikan Stok'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAdjustDialog(BuildContext context) async {
    final adjustmentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await Get.dialog<double>(
      AlertDialog(
        title: Text(
          'Penyesuaian Stok (${widget.stok.nama})',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: MBGSizes.spaceBtwItems),
            Form(
              key: formKey,
              child: TextFormField(
                controller: adjustmentController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Nilai Penyesuaian (kg)',
                  prefixIcon: Icon(Iconsax.chart),
                  suffixText: 'kg',
                ),
                validator: (value) {
                  final validation = MBGValidator.validateRequired(
                    value,
                    fieldName: 'Nilai penyesuaian',
                  );
                  if (validation != null) return validation;
                  final parsed = double.tryParse(value!);
                  if (parsed == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwItems),
            Text(
              'Masukkan nilai positif untuk menambah stok, atau nilai negatif untuk mengurangi stok.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
            ),
            const SizedBox(height: MBGSizes.spaceBtwItems),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() != true) return;
              final parsed = double.parse(adjustmentController.text.trim());
              Get.back(result: parsed);
            },
            child: Text(
              'Terapkan',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );

    if (result != null) {
      await _stockController.adjustStok(
        stokId: widget.stok.id,
        adjustment: result,
      );

      // Update local form value with the latest stok value
      StokModel? updated;
      for (final item in _stockController.stokList) {
        if (item.id == widget.stok.id) {
          updated = item;
          break;
        }
      }

      if (updated != null) {
        final latest = updated;
        setState(() {
          _stokKgController.text = latest.stokKg.toString();
          _selectedCategory = latest.kategori;
        });
      }
    }
  }
}
