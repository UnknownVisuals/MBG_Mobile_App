import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

/// Widget untuk menampilkan daftar menu hari ini di dashboard sekolah (UI-only)
class SekolahMenuCardWidget extends StatelessWidget {
  const SekolahMenuCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MBGHelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: isDarkMode ? MBGColors.dark : MBGColors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? MBGColors.lightGrey.withValues(alpha: 0.1)
              : MBGColors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Header ===
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MBGColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.note, color: MBGColors.primary, size: 22),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems),
              Text(
                'Today\'s Menu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? MBGColors.white : MBGColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems),

          // === List Menu Hari Ini ===
          _MenuItem(
            name: 'Nasi Goreng Telur',
            calories: '350 kcal',
            icon: Iconsax.cup,
          ),
          const Divider(),
          _MenuItem(
            name: 'Sayur Bayam',
            calories: '120 kcal',
            icon: Iconsax.coffee,
          ),
          const Divider(),
          _MenuItem(
            name: 'Ayam Bakar',
            calories: '250 kcal',
            icon: Iconsax.coffee,
          ),
          const Divider(),
          _MenuItem(
            name: 'Buah Pisang',
            calories: '90 kcal',
            icon: Iconsax.cup,
          ),
        ],
      ),
    );
  }
}

/// Item kecil untuk tiap menu harian
class _MenuItem extends StatelessWidget {
  final String name;
  final String calories;
  final IconData icon;

  const _MenuItem({
    required this.name,
    required this.calories,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: MBGColors.primary, size: 22),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: MBGHelperFunctions.isDarkMode(context)
              ? MBGColors.white
              : MBGColors.dark,
        ),
      ),
      subtitle: Text(
        calories,
        style: const TextStyle(fontSize: 12, color: MBGColors.grey),
      ),
      trailing: const Icon(
        Iconsax.arrow_right_3,
        size: 18,
        color: MBGColors.grey,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import '../../../../../utils/constants/colors.dart';
// import '../../../../../utils/constants/sizes.dart';

// /// Menu card widget for sekolah dashboard
// class SekolahMenuCardWidget extends StatelessWidget {
//   final dynamic menu;

//   const SekolahMenuCardWidget({super.key, required this.menu});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
//       padding: const EdgeInsets.all(MBGSizes.md),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
//         border: Border.all(color: Colors.grey[300]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.05),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: MBGColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Iconsax.note, color: MBGColors.primary, size: 24),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Week ${menu.mingguanKe}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${DateFormat('dd MMM').format(menu.tanggalMulai)} - ${DateFormat('dd MMM yyyy').format(menu.tanggalSelesai)}',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
