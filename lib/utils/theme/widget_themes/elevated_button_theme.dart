import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class MBGElevatedButtonTheme {
  MBGElevatedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MBGColors.light,
      backgroundColor: MBGColors.primary,
      disabledForegroundColor: MBGColors.darkGrey,
      disabledBackgroundColor: MBGColors.buttonDisabled,
      side: const BorderSide(color: MBGColors.primary),
      textStyle: const TextStyle(
        fontSize: 16,
        color: MBGColors.textWhite,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: MBGSizes.buttonHeight,
        horizontal: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MBGSizes.buttonRadius),
      ),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MBGColors.light,
      backgroundColor: MBGColors.primary,
      disabledForegroundColor: MBGColors.darkGrey,
      disabledBackgroundColor: MBGColors.darkerGrey,
      side: const BorderSide(color: MBGColors.primary),
      textStyle: const TextStyle(
        fontSize: 16,
        color: MBGColors.textWhite,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: MBGSizes.buttonHeight,
        horizontal: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MBGSizes.buttonRadius),
      ),
    ),
  );
}
