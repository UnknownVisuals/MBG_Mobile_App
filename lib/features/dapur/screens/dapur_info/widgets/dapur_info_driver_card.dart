import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoDriverCard extends StatelessWidget {
  const DapurInfoDriverCard({super.key, required this.driver});

  final DriversSummary driver;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB86DB8), Color(0xFFC73D51)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(MBGSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: const Icon(
                  Iconsax.truck_fast,
                  color: MBGColors.white,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  driver.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MBGColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          const Divider(color: MBGColors.grey),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              const Icon(
                Iconsax.direct_right,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  driver.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: MBGColors.textWhite),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              const Icon(
                Iconsax.call,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Text(
                driver.phone,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MBGColors.textWhite),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems / 2),
          Row(
            children: [
              const Icon(
                Iconsax.car,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Text(
                driver.nomorKendaraan,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MBGColors.textWhite),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
