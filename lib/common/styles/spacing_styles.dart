import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBGSpacingStyles {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.fromLTRB(
    MBGSizes.defaultSpace,
    MBGSizes.appBarHeight,
    MBGSizes.defaultSpace,
    MBGSizes.defaultSpace,
  );

  static const EdgeInsetsGeometry homeScreenPadding = EdgeInsets.fromLTRB(
    MBGSizes.defaultSpace,
    MBGSizes.defaultSpace,
    MBGSizes.defaultSpace,
    0,
  );
}
