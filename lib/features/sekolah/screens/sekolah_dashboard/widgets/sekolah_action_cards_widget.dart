import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

/// Sekolah Action Cards — hanya untuk tampilan UI
class SekolahActionCardsWidget extends StatelessWidget {
  const SekolahActionCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // === Card 1: Absensi Hari Ini ===
        Expanded(
          child: _ActionCard(
            title: 'Absensi Hari Ini',
            icon: Iconsax.user_tick,
            color: MBGColors.primary,
            onTap: () {},
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        // === Card 2: Menu Hari Ini ===
        Expanded(
          child: _ActionCard(
            title: 'Menu Hari Ini',
            icon: Iconsax.note,
            color: MBGColors.success,
            onTap: () {},
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        // === Card 3: Pengiriman ===
        Expanded(
          child: _ActionCard(
            title: 'Pengiriman',
            icon: Iconsax.truck,
            color: MBGColors.warning,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: MBGSizes.md,
          horizontal: MBGSizes.sm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: MBGSizes.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../../../utils/constants/sizes.dart';

// /// Action stat cards for quick navigation
// class SekolahActionCardsWidget extends StatelessWidget {
//   const SekolahActionCardsWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: InkWell(
//             onTap: () => Get.toNamed('/sekolah/absensi'),
//             child: _ActionCard(
//               icon: Iconsax.clipboard_text,
//               label: 'Record Attendance',
//               color: Colors.blue,
//             ),
//           ),
//         ),
//         const SizedBox(width: MBGSizes.spaceBtwItems),
//         Expanded(
//           child: InkWell(
//             onTap: () => Get.toNamed('/sekolah/qr-scanner'),
//             child: _ActionCard(
//               icon: Iconsax.scan_barcode,
//               label: 'Scan Delivery',
//               color: Colors.green,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ActionCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;

//   const _ActionCard({
//     required this.icon,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(MBGSizes.md),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 32),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
