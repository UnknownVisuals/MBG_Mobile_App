import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBGSectionHeading extends StatelessWidget {
  const MBGSectionHeading({
    super.key,
    required this.title,
    this.textColor,
    this.showLeadingIcon = false,
    this.leadingIcon,
    this.showActionButton = false,
    this.actionButtonTitle = 'See All',
    this.onPressed,
  });

  final String title;
  final Color? textColor;
  final bool showLeadingIcon;
  final IconData? leadingIcon;
  final bool showActionButton;
  final String? actionButtonTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (showLeadingIcon) ...[
              Icon(leadingIcon, color: MBGColors.primary),
              const SizedBox(width: MBGSizes.spaceBtwItems / 2),
            ],
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall!.apply(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        if (showActionButton)
          TextButton(
            onPressed: onPressed,
            child: Text(
              actionButtonTitle!,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
      ],
    );
  }
}
