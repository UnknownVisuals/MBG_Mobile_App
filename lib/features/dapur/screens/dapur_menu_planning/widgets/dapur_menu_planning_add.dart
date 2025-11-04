import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Full screen mock for creating a weekly menu plan.
class DapurMenuPlanningAdd extends StatelessWidget {
  const DapurMenuPlanningAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Form Tambah Menu Planning Mingguan',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: MBGSizes.spaceBtwSections),

            DropdownButtonFormField<String>(
              items: [],
              onChanged: (_) {},
              decoration: const InputDecoration(
                labelText: 'Sekolah',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Iconsax.building_3),
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Mingguan Ke',
                prefixIcon: Icon(Iconsax.hashtag),
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tanggal Mulai',
                prefixIcon: Icon(Iconsax.calendar_1),
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tanggal Selesai',
                prefixIcon: Icon(Iconsax.calendar_2),
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.spaceBtwItems),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Save Plan',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: MBGColors.textWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
