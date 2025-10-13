import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class MBGChipTheme {
  MBGChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: MBGColors.grey.withValues(alpha: 0.4),
    labelStyle: const TextStyle(color: MBGColors.black),
    selectedColor: MBGColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: MBGColors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: MBGColors.darkerGrey,
    labelStyle: TextStyle(color: MBGColors.white),
    selectedColor: MBGColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: MBGColors.white,
  );
}
