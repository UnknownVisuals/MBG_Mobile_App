import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Full screen mock for creating a daily menu entry.
class DapurMenuHarianAdd extends StatelessWidget {
  const DapurMenuHarianAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
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
              initialValue: '2025-10-31',
              decoration: const InputDecoration(
                labelText: 'Tanggal (YYYY-MM-DD)',
                prefixIcon: Icon(Iconsax.calendar_1),
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            TextFormField(
              initialValue: 'Nasi Goreng Spesial',
              decoration: const InputDecoration(
                labelText: 'Nama Menu',
                prefixIcon: Icon(Iconsax.note_2),
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            TextFormField(
              initialValue: '15000.0',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Biaya per Tray (Rp)',
                prefixIcon: Icon(Iconsax.money),
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '06:00',
                    decoration: const InputDecoration(
                      labelText: 'Jam Mulai Masak',
                      prefixIcon: Icon(Iconsax.clock),
                    ),
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: TextFormField(
                    initialValue: '08:00',
                    decoration: const InputDecoration(
                      labelText: 'Jam Selesai Masak',
                      prefixIcon: Icon(Iconsax.clock_1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '550.5',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Kalori (kcal)',
                      prefixIcon: Icon(Iconsax.activity),
                    ),
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: TextFormField(
                    initialValue: '25.5',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Protein (g)',
                      prefixIcon: Icon(Iconsax.security_user),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '75.0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Karbohidrat (g)',
                      prefixIcon: Icon(Iconsax.bezier),
                    ),
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: TextFormField(
                    initialValue: '15.0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Lemak (g)',
                      prefixIcon: Icon(Iconsax.chart_21),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.md),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: MBGColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Save Menu'),
          ),
        ),
      ),
    );
  }
}
