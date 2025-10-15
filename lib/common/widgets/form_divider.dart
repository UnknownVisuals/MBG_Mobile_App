import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class MBGFormDivider extends StatelessWidget {
  const MBGFormDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final bool dark = MBGHelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? MBGColors.darkGrey : MBGColors.darkerGrey,
            thickness: 0.5,
            indent: 30,
            endIndent: 10,
          ),
        ),
        Text(dividerText, style: Theme.of(context).textTheme.labelMedium),
        Flexible(
          child: Divider(
            color: dark ? MBGColors.darkGrey : MBGColors.darkerGrey,
            thickness: 0.5,
            indent: 10,
            endIndent: 30,
          ),
        ),
      ],
    );
  }
}
