import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBChipFilter extends StatelessWidget {
  const MBChipFilter({
    super.key,
    required this.chipFilterString,
    required this.chipFilterColor,
    required this.chipFilterIcon,
    this.isSelected = false,
    this.onTap,
  });

  final String chipFilterString;
  final Color chipFilterColor;
  final IconData chipFilterIcon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: Icon(
          chipFilterIcon,
          color: MBGColors.white,
          size: MBGSizes.iconSm,
        ),
        label: Text(
          chipFilterString,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: MBGColors.white),
        ),
        backgroundColor: isSelected
            ? chipFilterColor
            : chipFilterColor.withValues(alpha: 0.3),
        side: isSelected
            ? BorderSide(color: chipFilterColor, width: 2)
            : BorderSide.none,
      ),
    );
  }
}
