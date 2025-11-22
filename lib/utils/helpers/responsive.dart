import 'package:flutter/material.dart';

class MBGResponsive {
  /// AUTO-SCALE berdasarkan tinggi layar aktual.
  ///
  /// Catatan:
  /// - baseHeight = tinggi ideal ketika device besar (mis. 200–250 px)
  /// - minFactor = seberapa kecil boleh dikurangi (default 40%)
  ///
  /// Rumus:
  ///   scaledHeight = baseHeight * factor
  ///   factor = clamp(screenHeight / 850, minFactor, 1.0)
  ///
  /// Hasil:
  /// - HP layar besar → tinggi sesuai
  /// - Tablet landscape (tinggi pendek) → mengecil otomatis → tidak overflow
  static double autoScaleHeight(
    BuildContext context,
    double baseHeight, {
    double minFactor = 0.40,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Dibagi 850 karena rata-rata tinggi HP normal.
    double factor = screenHeight / 850;

    if (factor > 1.0) factor = 1.0;
    if (factor < minFactor) factor = minFactor;

    return baseHeight * factor;
  }
}
