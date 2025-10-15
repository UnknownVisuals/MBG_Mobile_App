import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class MBGShadowStyles {
  static final productCardShadow = BoxShadow(
    color: MBGColors.darkGrey.withValues(alpha: 0.1),
    blurRadius: 50.0,
    spreadRadius: 7.0,
    offset: const Offset(0, 2),
  );
}
