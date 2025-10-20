import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class MBGShadowStyles {
  static final primaryCardShadow = BoxShadow(
    color: MBGColors.primary.withValues(alpha: 0.4),
    blurRadius: 16.0,
    spreadRadius: 2.0,
    offset: const Offset(0, 4),
  );
}
