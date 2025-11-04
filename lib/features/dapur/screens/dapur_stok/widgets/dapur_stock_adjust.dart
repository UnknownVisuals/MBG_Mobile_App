import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_stock_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stock_model.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurStockAdjust extends StatelessWidget {
  const DapurStockAdjust({super.key, required this.stok});

  final DapurStokModel stok;

  @override
  Widget build(BuildContext context) {
    // Dependencies
    final DapurStokController controller = Get.find<DapurStokController>();

    // Current stok value
    final TextEditingController adjustmentController = TextEditingController();

    // Current stok value
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Sesuaikan Stok',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),

              // Info
              Text(
                'Stok saat ini: ${stok.stokKg} kg',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),

              Text(
                'Masukkan nilai positif untuk menambah stok, atau nilai negatif untuk mengurangi stok.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),

              // Adjustment Input
              TextFormField(
                controller: adjustmentController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Penyesuaian (kg)',
                  hintText: 'Contoh: 1 atau -1',
                  prefixIcon: Icon(Iconsax.edit),
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai penyesuaian harus diisi';
                  }
                  final adjustment = double.tryParse(value);
                  if (adjustment == null) {
                    return 'Nilai penyesuaian harus berupa angka';
                  }
                  if (adjustment == 0) {
                    return 'Nilai penyesuaian tidak boleh nol';
                  }
                  final newStok = stok.stokKg + adjustment;
                  if (newStok < 0) {
                    return 'Stok tidak boleh kurang dari 0 kg';
                  }
                  return null;
                },
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final adjustment = double.parse(
                          adjustmentController.text,
                        );

                        await controller.adjustStok(
                          stokId: stok.id,
                          adjustment: adjustment,
                        );
                      }
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
