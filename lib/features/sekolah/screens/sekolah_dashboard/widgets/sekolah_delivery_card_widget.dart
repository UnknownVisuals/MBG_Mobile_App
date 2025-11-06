import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

/// Widget untuk menampilkan status pengiriman bahan makanan (UI-only)
class SekolahDeliveryCardWidget extends StatelessWidget {
  const SekolahDeliveryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: MBGColors.white,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: MBGColors.grey.withOpacity(0.3)),
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
                  color: MBGColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.truck_fast, color: MBGColors.warning, size: 22),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems),
              const Text(
                'Pending Delivery',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: MBGColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems),

          // === Status List (dummy UI) ===
          _DeliveryStatusItem(
            title: 'Bahan Pokok Pagi',
            status: 'Dalam Perjalanan',
            color: MBGColors.warning,
            icon: Iconsax.timer,
          ),
          const Divider(),
          _DeliveryStatusItem(
            title: 'Menu Siang',
            status: 'Sudah Diterima',
            color: MBGColors.success,
            icon: Iconsax.tick_circle,
          ),
          const Divider(),
          _DeliveryStatusItem(
            title: 'Bahan Tambahan',
            status: 'Menunggu Konfirmasi',
            color: MBGColors.info,
            icon: Iconsax.archive_1,
          ),
        ],
      ),
    );
  }
}

/// Item kecil untuk tiap status pengiriman
class _DeliveryStatusItem extends StatelessWidget {
  final String title;
  final String status;
  final Color color;
  final IconData icon;

  const _DeliveryStatusItem({
    required this.title,
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: MBGColors.dark,
        ),
      ),
      subtitle: Text(
        status,
        style: TextStyle(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Iconsax.arrow_right_3, size: 18, color: MBGColors.grey),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../../../utils/constants/sizes.dart';

// /// Delivery card widget for sekolah dashboard
// class SekolahDeliveryCardWidget extends StatelessWidget {
//   final dynamic delivery;

//   const SekolahDeliveryCardWidget({super.key, required this.delivery});

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = delivery.status == 'PENDING'
//         ? Colors.orange
//         : Colors.blue;

//     return Container(
//       margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
//       padding: const EdgeInsets.all(MBGSizes.md),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Iconsax.truck, color: statusColor, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Delivery from Kitchen',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${delivery.jumlahTray} trays • ${delivery.jumlahKeranjang} baskets',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               delivery.status,
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.bold,
//                 color: statusColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
