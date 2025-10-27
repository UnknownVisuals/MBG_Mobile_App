import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoKaryawanCard extends StatelessWidget {
  const DapurInfoKaryawanCard({super.key, required this.karyawan});

  final KaryawanSummary karyawan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A7ABD), Color(0xFF00A8B3)],
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
                  Iconsax.user,
                  color: MBGColors.white,
                  size: MBGSizes.iconMd,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  karyawan.nama,
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
                Iconsax.briefcase,
                color: MBGColors.white,
                size: MBGSizes.iconSm,
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
              Expanded(
                child: Text(
                  karyawan.posisi,
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.sm,
              vertical: MBGSizes.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
            ),
            child: Text(
              karyawan.status,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: MBGColors.textWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
