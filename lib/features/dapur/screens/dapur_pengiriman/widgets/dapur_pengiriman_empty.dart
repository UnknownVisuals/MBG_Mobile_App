import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurPengirimanEmpty extends StatelessWidget {
  const DapurPengirimanEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.truck_fast,
            size: MBGSizes.iconLg,
            color: MBGColors.grey,
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'Belum ada pengiriman',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: MBGColors.grey),
          ),
          Text(
            'Buat pengiriman baru dengan tombol + di bawah',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: MBGColors.grey),
          ),
        ],
      ),
    );
  }
}
