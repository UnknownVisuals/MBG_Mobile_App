import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBGTextFormFieldTheme {
  MBGTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: MBGColors.darkGrey,
    suffixIconColor: MBGColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: MBGSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
      fontSize: MBGSizes.fontSizeMd,
      color: MBGColors.black,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: MBGSizes.fontSizeSm,
      color: MBGColors.black,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: MBGColors.black.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MBGColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MBGColors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MBGColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MBGColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: MBGColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: MBGColors.darkGrey,
    suffixIconColor: MBGColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: MBGSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
      fontSize: MBGSizes.fontSizeMd,
      color: MBGColors.white,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: MBGSizes.fontSizeSm,
      color: MBGColors.white,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: MBGColors.white.withOpacity(0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MBGColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MBGColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MBGColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MBGColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MBGSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: MBGColors.warning),
    ),
  );
}
