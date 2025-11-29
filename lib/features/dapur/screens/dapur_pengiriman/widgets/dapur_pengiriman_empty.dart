import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurPengirimanEmpty extends StatelessWidget {
  const DapurPengirimanEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = (constraints.maxWidth / 400).clamp(
            0.7,
            1.2,
          ); // Responsif

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.truck_fast,
                size: MBGSizes.iconLg * scale,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),

              SizedBox(height: MBGSizes.spaceBtwItems * scale),

              // Judul adaptif
              FittedBox(
                child: Text(
                  'Belum ada pengiriman',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),

              SizedBox(height: 4 * scale),

              // Subtitle adaptif
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.8,
                ),
                child: Text(
                  'Buat pengiriman baru dengan tombol + di bawah',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
