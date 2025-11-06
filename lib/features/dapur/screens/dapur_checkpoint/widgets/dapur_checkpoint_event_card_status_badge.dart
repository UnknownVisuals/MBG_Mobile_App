import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurCheckpointEventCardStatusBadge extends StatelessWidget {
  const DapurCheckpointEventCardStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MBGSizes.sm,
        vertical: MBGSizes.xs,
      ),
      decoration: BoxDecoration(
        color: MBGColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
      ),
      child: Text(
        'Selesai',
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: MBGColors.success),
      ),
    );
  }
}
