import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/http/dapur_service.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/constants/image_strings.dart';
import '../models/kalender_akademik_model.dart';

class KalenderAkademikController extends GetxController {
  static KalenderAkademikController get instance => Get.find();

  final DapurService _dapurService = Get.find<DapurService>();

  // Observable lists
  final RxList<KalenderAkademikModel> allKalender =
      <KalenderAkademikModel>[].obs;
  final RxMap<DateTime, List<KalenderAkademikModel>> kalenderByDate =
      <DateTime, List<KalenderAkademikModel>>{}.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Selected date for calendar
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> focusedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchKalenderAkademik();
  }

  /// Fetch all kalender akademik
  Future<void> fetchKalenderAkademik() async {
    try {
      isLoading.value = true;
      final kalenderList = await _dapurService.getAllKalenderAkademik();
      allKalender.value = kalenderList;

      // Group by date
      kalenderByDate.clear();
      for (var event in kalenderList) {
        final dateKey = DateTime(
          event.tanggal.year,
          event.tanggal.month,
          event.tanggal.day,
        );
        if (!kalenderByDate.containsKey(dateKey)) {
          kalenderByDate[dateKey] = [];
        }
        kalenderByDate[dateKey]!.add(event);
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat kalender akademik: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new kalender entry
  Future<bool> createKalender({
    required String nama,
    required String deskripsi,
    required DateTime tanggal,
    required String jenis,
  }) async {
    try {
      MBGFullScreenLoader.openLoadingDialog(
        'Membuat event...',
        MBGImages.onBoardingImage1,
      );

      await _dapurService.createKalenderAkademik({
        'nama': nama,
        'deskripsi': deskripsi,
        'tanggal': DateFormat('yyyy-MM-dd').format(tanggal),
        'jenis': jenis,
      });

      MBGFullScreenLoader.stopLoading();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Event berhasil ditambahkan',
      );

      // Refresh the list
      await fetchKalenderAkademik();
      return true;
    } catch (e) {
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal membuat event: $e',
      );
      return false;
    }
  }

  /// Update kalender entry
  Future<bool> updateKalender({
    required String id,
    required String nama,
    required String deskripsi,
    required DateTime tanggal,
    required String jenis,
  }) async {
    try {
      MBGFullScreenLoader.openLoadingDialog(
        'Memperbarui event...',
        MBGImages.onBoardingImage1,
      );

      await _dapurService.updateKalenderAkademik(id, {
        'nama': nama,
        'deskripsi': deskripsi,
        'tanggal': DateFormat('yyyy-MM-dd').format(tanggal),
        'jenis': jenis,
      });

      MBGFullScreenLoader.stopLoading();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Event berhasil diperbarui',
      );

      // Refresh the list
      await fetchKalenderAkademik();
      return true;
    } catch (e) {
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memperbarui event: $e',
      );
      return false;
    }
  }

  /// Delete kalender entry
  Future<bool> deleteKalender(KalenderAkademikModel kalender) async {
    try {
      MBGFullScreenLoader.openLoadingDialog(
        'Menghapus event...',
        MBGImages.onBoardingImage1,
      );

      await _dapurService.deleteKalenderAkademik(kalender.id);

      MBGFullScreenLoader.stopLoading();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Event berhasil dihapus',
      );

      // Refresh the list
      await fetchKalenderAkademik();
      return true;
    } catch (e) {
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal menghapus event: $e',
      );
      return false;
    }
  }

  /// Check if a date is a holiday
  Future<bool> isHoliday(DateTime date) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      return await _dapurService.checkHoliday(dateStr);
    } catch (e) {
      return false;
    }
  }

  /// Get events for a specific date
  List<KalenderAkademikModel> getEventsForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return kalenderByDate[dateKey] ?? [];
  }

  /// Get color for event type
  Color getEventColor(String jenis) {
    switch (jenis) {
      case 'LIBUR':
        return Colors.red;
      case 'KEGIATAN':
        return Colors.blue;
      case 'PENTING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Get icon for event type
  IconData getEventIcon(String jenis) {
    switch (jenis) {
      case 'LIBUR':
        return Icons.beach_access;
      case 'KEGIATAN':
        return Icons.event;
      case 'PENTING':
        return Icons.priority_high;
      default:
        return Icons.calendar_today;
    }
  }

  /// Get label for event type
  String getEventLabel(String jenis) {
    switch (jenis) {
      case 'LIBUR':
        return 'Libur';
      case 'KEGIATAN':
        return 'Kegiatan';
      case 'PENTING':
        return 'Penting';
      default:
        return jenis;
    }
  }
}
