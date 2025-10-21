import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/appbar.dart';
import '../../../utils/http/sekolah_service.dart';
import '../../authentication/controllers/user_controller.dart';
import '../../dapur/models/menu_planning_model.dart';

class MenuViewScreen extends StatefulWidget {
  const MenuViewScreen({super.key});

  @override
  State<MenuViewScreen> createState() => _MenuViewScreenState();
}

class _MenuViewScreenState extends State<MenuViewScreen> {
  final SekolahService _sekolahService = Get.find<SekolahService>();
  final UserController _userController = Get.find<UserController>();
  List<MenuPlanningModel> _menuList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  String? get _sekolahId {
    final sekolahAsPIC = _userController.user.value?.sekolahAsPIC;
    if (sekolahAsPIC == null || sekolahAsPIC.isEmpty) return null;
    return sekolahAsPIC[0].id;
  }

  Future<void> _loadMenu() async {
    setState(() => _isLoading = true);
    try {
      final sekolahId = _sekolahId;
      if (sekolahId == null) {
        throw Exception('Anda tidak memiliki akses ke sekolah');
      }
      final menus = await _sekolahService.getMenuBySekolah(sekolahId);
      setState(() {
        _menuList = menus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', e.toString());
    }
  }

  Color _getWeekColor(int week) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[(week - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MBGAppBar(
        title: Text('Menu Mingguan'),
        showBackArrow: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _menuList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada menu',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Menu akan tersedia setelah dapur membuat perencanaan',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadMenu,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _menuList.length,
                itemBuilder: (context, index) {
                  final planning = _menuList[index];
                  final weekColor = _getWeekColor(planning.mingguanKe);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // TODO: Navigate to detail if needed
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
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
                                    'Minggu ke-${planning.mingguanKe}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat(
                                          'dd MMM yyyy',
                                        ).format(planning.tanggalMulai),
                                        style: TextStyle(
                                          color: weekColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        's/d ${DateFormat('dd MMM yyyy').format(planning.tanggalSelesai)}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: weekColor.withOpacity(0.1),
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
            ),
    );
  }
}
