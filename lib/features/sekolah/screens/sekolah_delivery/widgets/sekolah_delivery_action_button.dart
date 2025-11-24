import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahDeliveryActionButton extends StatelessWidget {
  const SekolahDeliveryActionButton({
    super.key,
    required this.onTap,
    this.isProcessing = false,
  });

  final VoidCallback onTap;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
        onTap: isProcessing ? null : onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: MBGColors.primaryGradient,
            borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
            boxShadow: [
              BoxShadow(
                color: MBGColors.primary.withValues(alpha: 0.4),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: MBGSizes.lg,
            vertical: MBGSizes.md,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
                decoration: BoxDecoration(
                  color: MBGColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
                ),
                child: const Icon(
                  Iconsax.scan_barcode,
                  color: MBGColors.white,
                  size: MBGSizes.iconLg,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan QR Sekolah',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MBGColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: MBGSizes.xs),
                    Text(
                      'Tandai pengiriman sudah sampai ke sekolah.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MBGColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
              if (isProcessing)
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: MBGColors.white,
                    strokeWidth: 2,
                  ),
                )
              else
                const Icon(
                  Iconsax.arrow_right_3,
                  color: MBGColors.textWhite,
                  size: MBGSizes.iconMd,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
