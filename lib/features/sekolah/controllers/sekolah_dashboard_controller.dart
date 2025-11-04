import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_absensi_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:intl/intl.dart';

class SekolahDashboardController extends GetxController {
  final SekolahService _sekolahService = Get.find<SekolahService>();

  // Observable variables
  final RxList<SekolahAbsensiModel> todaysAbsensi = <SekolahAbsensiModel>[].obs;
  final RxList<SekolahKelasModel> classes = <SekolahKelasModel>[].obs;
  final RxList<DapurMenuPlanningModel> todaysMenus =
      <DapurMenuPlanningModel>[].obs;
  final RxList<SekolahPengirimanModel> pendingDeliveries =
      <SekolahPengirimanModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt totalPresentToday = 0.obs;
  final RxInt totalClassesToday = 0.obs;
  final RxInt pendingDeliveriesCount = 0.obs;
  final RxDouble attendanceRate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Fetch all dashboard data
  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchTodaysAttendance(),
        fetchPendingDeliveries(),
        fetchTodaysMenu(),
      ]);
    } catch (e) {
      Get.log('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch today's attendance
  Future<void> fetchTodaysAttendance() async {
    try {
      // Get sekolah ID from auth - for now using placeholder
      // TODO: Get from authentication service
      final sekolahId = Get.find<String>(tag: 'sekolahId');

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Get total attendance for today
      final response = await _sekolahService.getTotalAbsensi(sekolahId, today);
      if (response['totalHadir'] != null) {
        totalPresentToday.value = response['totalHadir'] as int;
        totalClassesToday.value = response['jumlahKelas'] as int;

        // Calculate attendance rate
        if (totalClassesToday.value > 0) {
          final totalStudents = classes.fold<int>(
            0,
            (sum, kelas) => sum + (kelas.jumlahSiswa ?? 0),
          );
          if (totalStudents > 0) {
            attendanceRate.value =
                (totalPresentToday.value / totalStudents) * 100;
          }
        }
      }
    } catch (e) {
      Get.log('Error fetching today\'s attendance: $e');
      // If sekolahId not found, skip for now
    }
  }

  /// Fetch pending deliveries for school
  Future<void> fetchPendingDeliveries() async {
    try {
      // Get sekolah ID from auth
      final sekolahId = Get.find<String>(tag: 'sekolahId');

      final deliveries = await _sekolahService.getPengirimanBySekolah(
        sekolahId,
      );

      // Filter for pending and in-transit
      pendingDeliveries.value = deliveries.where((delivery) {
        return delivery.status == 'PENDING' || delivery.status == 'IN_TRANSIT';
      }).toList();

      pendingDeliveriesCount.value = pendingDeliveries.length;
    } catch (e) {
      Get.log('Error fetching pending deliveries: $e');
    }
  }

  /// Fetch today's menu
  Future<void> fetchTodaysMenu() async {
    try {
      // Get sekolah ID from auth
      final sekolahId = Get.find<String>(tag: 'sekolahId');

      final menus = await _sekolahService.getMenuBySekolah(sekolahId);

      // Filter for today's date
      final today = DateTime.now();
      todaysMenus.value = menus.where((menu) {
        return menu.tanggalMulai.isBefore(today.add(Duration(days: 1))) &&
            menu.tanggalSelesai.isAfter(today.subtract(Duration(days: 1)));
      }).toList();
    } catch (e) {
      Get.log('Error fetching today\'s menu: $e');
    }
  }

  /// Get attendance status color
  Color getAttendanceStatusColor() {
    if (attendanceRate.value >= 80) return Colors.green;
    if (attendanceRate.value >= 60) return Colors.orange;
    return Colors.red;
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }
}
