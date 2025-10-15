import 'package:flutter/material.dart';
import 'package:get/get.dart';

class REYSectionHeading extends StatelessWidget {
  const REYSectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.buttonTitle,
    required this.title,
    this.showActionButton = false,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title;
  final String? buttonTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonTitle ?? 'defaultViewAll'.tr,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
      ],
    );
  }
}
