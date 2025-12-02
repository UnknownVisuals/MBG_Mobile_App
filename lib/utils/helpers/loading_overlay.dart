import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/splash_screen.dart';

/// Loading overlay utility for showing splash screen during async operations
class MBGLoadingOverlay {
  static bool _isShowing = false;

  /// Show full-screen loading splash
  static void show() {
    if (_isShowing) return;
    _isShowing = true;

    Get.dialog(
      const MBGSplashScreen(),
      barrierDismissible: false,
      barrierColor: Colors.transparent,
    );
  }

  /// Hide the loading splash
  static void hide() {
    if (!_isShowing) return;
    _isShowing = false;

    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  /// Execute an async function with loading overlay
  /// Shows splash screen during execution, hides after completion
  static Future<T> during<T>(Future<T> Function() asyncFunction) async {
    try {
      show();
      final result = await asyncFunction();
      return result;
    } finally {
      hide();
    }
  }
}
