import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import '../../constants/colors.dart';

class MBGAppBarTheme {
  MBGAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: MBGColors.black, size: MBGSizes.iconMd),
    actionsIconTheme: IconThemeData(
      color: MBGColors.black,
      size: MBGSizes.iconMd,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: MBGColors.black,
    ),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: MBGColors.black, size: MBGSizes.iconMd),
    actionsIconTheme: IconThemeData(
      color: MBGColors.white,
      size: MBGSizes.iconMd,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: MBGColors.white,
    ),
  );
}
