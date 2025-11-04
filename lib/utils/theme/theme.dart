import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/theme/widget_themes/appbar_theme.dart';
import 'package:mbg_mobile_app/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:mbg_mobile_app/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:mbg_mobile_app/utils/theme/widget_themes/chip_theme.dart';
import 'package:mbg_mobile_app/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:mbg_mobile_app/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:mbg_mobile_app/utils/theme/widget_themes/text_field_theme.dart';
import 'package:mbg_mobile_app/utils/theme/widget_themes/text_theme.dart';

class MBGAppTheme {
  MBGAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: MBGColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          surface: MBGColors.white,
          onSurface: MBGColors.black,
          surfaceContainerHigh: MBGColors.white,
        ),
    disabledColor: MBGColors.grey,
    textTheme: MBGTextTheme.lightTextTheme,
    chipTheme: MBGChipTheme.lightChipTheme,
    scaffoldBackgroundColor: MBGColors.white,
    appBarTheme: MBGAppBarTheme.lightAppBarTheme,
    checkboxTheme: MBGCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: MBGBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: MBGElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MBGOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: MBGTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: MBGColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          surface: MBGColors.dark,
          onSurface: MBGColors.white,
          surfaceContainerHigh: MBGColors.black,
        ),
    disabledColor: MBGColors.grey,
    textTheme: MBGTextTheme.darkTextTheme,
    chipTheme: MBGChipTheme.darkChipTheme,
    scaffoldBackgroundColor: MBGColors.black,
    appBarTheme: MBGAppBarTheme.darkAppBarTheme,
    checkboxTheme: MBGCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: MBGBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: MBGElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MBGOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: MBGTextFormFieldTheme.darkInputDecorationTheme,
  );
}
