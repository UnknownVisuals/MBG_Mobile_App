import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';

class MenuViewScreen extends StatelessWidget {
  const MenuViewScreen({super.key});

  // Warna badge berdasarkan minggu
  Color _getWeekColor(int week, bool isDark) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    // Untuk dark mode: warna sedikit lebih terang (agar kontras)
    final base = colors[(week - 1) % colors.length];
    return isDark ? base.withOpacity(0.85) : base;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    // Dummy data
    final dummyMenus = [
      {
        'mingguanKe': 1,
        'tanggalMulai': DateTime.now(),
        'tanggalSelesai': DateTime.now().add(const Duration(days: 6)),
      },
      {
        'mingguanKe': 2,
        'tanggalMulai': DateTime.now().add(const Duration(days: 7)),
        'tanggalSelesai': DateTime.now().add(const Duration(days: 13)),
      },
    ];

    final menus = dummyMenus;

    return Scaffold(
      appBar: const MBGAppBar(
        title: Text('Menu Mingguan'),
        showBackArrow: false,
      ),
      body: menus.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu,
                      size: 80, color: scheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada menu',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Menu akan tersedia setelah dapur membuat perencanaan',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final planning = menus[index];
                final weekColor =
                    _getWeekColor(planning['mingguanKe'] as int, isDark);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  color: scheme.surface,
                  shadowColor: scheme.shadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // ---------------------------
                              // BADGE "Minggu ke-x"
                              // ---------------------------
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: weekColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Minggu ke-${planning['mingguanKe']}',
                                  style: TextStyle(
                                    color: scheme.onPrimary, // adaptif!
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Tanggal mulai
                                    Text(
                                      DateFormat('dd MMM yyyy').format(
                                          planning['tanggalMulai']
                                              as DateTime),
                                      style: TextStyle(
                                        color: weekColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),

                                    // Tanggal selesai
                                    Text(
                                      's/d ${DateFormat('dd MMM yyyy').format(planning['tanggalSelesai'] as DateTime)}',
                                      style: TextStyle(
                                        color: scheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: scheme.onSurfaceVariant,
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // ---------------------------
                          // INFO BOX
                          // ---------------------------
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: weekColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: weekColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Klik untuk melihat menu harian lengkap',
                                    style: TextStyle(
                                      color: weekColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:mbg_mobile_app/common/widgets/appbar.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_menu_view_controller.dart';

// Color _getWeekColor(int week) {
//   final colors = [
//     Colors.blue,
//     Colors.green,
//     Colors.orange,
//     Colors.purple,
//     Colors.teal,
//   ];
//   return colors[(week - 1) % colors.length];
// }

// class MenuViewScreen extends GetView<SekolahMenuViewController> {
//   const MenuViewScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const MBGAppBar(
//         title: Text('Menu Mingguan'),
//         showBackArrow: false,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final menus = controller.menus;
//         if (menus.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Belum ada menu',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Menu akan tersedia setelah dapur membuat perencanaan',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: controller.refreshMenus,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: menus.length,
//             itemBuilder: (context, index) {
//               final planning = menus[index];
//               final weekColor = _getWeekColor(planning.mingguanKe);

//               return Card(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: InkWell(
//                   onTap: () {
//                     // TODO: Navigate to detail if needed
//                   },
//                   borderRadius: BorderRadius.circular(12),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: weekColor,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 'Minggu ke-${planning.mingguanKe}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     DateFormat(
//                                       'dd MMM yyyy',
//                                     ).format(planning.tanggalMulai),
//                                     style: TextStyle(
//                                       color: weekColor,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   Text(
//                                     's/d ${DateFormat('dd MMM yyyy').format(planning.tanggalSelesai)}',
//                                     style: TextStyle(
//                                       color: Colors.grey[600],
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               size: 16,
//                               color: Colors.grey[400],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: weekColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.info_outline,
//                                 color: weekColor,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   'Klik untuk melihat menu harian lengkap',
//                                   style: TextStyle(
//                                     color: weekColor,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
