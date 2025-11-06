import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DeliveryHistoryCardWidget extends StatelessWidget {
  final String status;
  final int jumlahTray;
  final int jumlahKeranjang;
  final String tanggal;
  final VoidCallback onTap;

  const DeliveryHistoryCardWidget({
    super.key,
    required this.status,
    required this.jumlahTray,
    required this.jumlahKeranjang,
    required this.tanggal,
    required this.onTap,
  });

  Color getStatusColor() {
    switch (status) {
      case 'PENDING':
        return MBGColors.warning;
      case 'DIAMBIL':
        return MBGColors.info;
      case 'DITERIMA':
        return MBGColors.success;
      default:
        return MBGColors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (status) {
      case 'PENDING':
        return Iconsax.timer;
      case 'DIAMBIL':
        return Iconsax.truck_fast;
      case 'DITERIMA':
        return Iconsax.tick_circle;
      default:
        return Iconsax.box;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: MBGSizes.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.md),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(MBGSizes.cardRadiusMd),
                ),
                child: Icon(getStatusIcon(), color: color),
              ),
              const SizedBox(width: MBGSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$jumlahTray tray • $jumlahKeranjang keranjang',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tanggal,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../models/sekolah_pengiriman_model.dart';

// /// Delivery history card widget
// class DeliveryHistoryCardWidget extends StatelessWidget {
//   final SekolahPengirimanModel delivery;
//   final VoidCallback onTap;
//   final Color Function(String) getStatusColor;
//   final IconData Function(String) getStatusIcon;

//   const DeliveryHistoryCardWidget({
//     super.key,
//     required this.delivery,
//     required this.onTap,
//     required this.getStatusColor,
//     required this.getStatusIcon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = getStatusColor(delivery.status);

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: statusColor.withOpacity(0.3), width: 1),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   getStatusIcon(delivery.status),
//                   color: statusColor,
//                   size: 28,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             delivery.status,
//                             style: TextStyle(
//                               color: statusColor,
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '${delivery.jumlahTray} tray • ${delivery.jumlahKeranjang} keranjang',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       DateFormat(
//                         'dd MMM yyyy HH:mm',
//                       ).format(delivery.createdAt),
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
