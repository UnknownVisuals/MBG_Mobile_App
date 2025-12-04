import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kalender_akademik_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';

class SekolahKalenderAkademikController extends GetxController {
  SekolahKalenderAkademikController({SekolahService? sekolahService})
    : _sekolahService = sekolahService ?? Get.find<SekolahService>();

  final SekolahService _sekolahService;

  final RxList<SekolahKalenderAkademikModel> allKalender =
      <SekolahKalenderAkademikModel>[].obs;
  final RxMap<DateTime, List<SekolahKalenderAkademikModel>> kalenderByDate =
      <DateTime, List<SekolahKalenderAkademikModel>>{}.obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> focusedDate = DateTime.now().obs;
  final Rxn<SekolahPagination> pagination = Rxn<SekolahPagination>();

  @override
  void onInit() {
    super.onInit();
    fetchKalenderAkademik();
  }

  Future<void> fetchKalenderAkademik() async {
    try {
      isLoading.value = true;
      final response = await _sekolahService.getKalenderAkademik();
      allKalender.assignAll(response.kalenders);
      pagination.value = response.pagination;
      _groupEventsByDate();
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Kalender Akademik',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Groups every event by each day it spans so the calendar can display markers.
  void _groupEventsByDate() {
    kalenderByDate.clear();
    for (final event in allKalender) {
      final start = event.tanggalMulai ?? event.tanggalSelesai;
      if (start == null) continue;
      final end = event.tanggalSelesai ?? start;
      var cursor = DateTime(start.year, start.month, start.day);
      final lastDay = DateTime(end.year, end.month, end.day);
      while (!cursor.isAfter(lastDay)) {
        kalenderByDate.putIfAbsent(cursor, () => []).add(event);
        cursor = cursor.add(const Duration(days: 1));
      }
    }
  }

  List<SekolahKalenderAkademikModel> getEventsForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return kalenderByDate[key] ?? [];
  }

  Future<void> createEvent(Map<String, dynamic> payload) async {
    try {
      MBGLoadingOverlay.show();
      await _sekolahService.createKalenderAkademik(payload);
      await fetchKalenderAkademik();
      MBGLoadingOverlay.hide();
      Get.back(); // Close form
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Event kalender berhasil ditambahkan',
      );
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(title: 'Gagal', message: e.toString());
    }
  }

  Future<void> updateEvent(String id, Map<String, dynamic> payload) async {
    try {
      MBGLoadingOverlay.show();
      await _sekolahService.updateKalenderAkademik(id, payload);
      await fetchKalenderAkademik();
      MBGLoadingOverlay.hide();
      Get.back(); // Close form
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Event kalender berhasil diperbarui',
      );
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(title: 'Gagal', message: e.toString());
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      MBGLoadingOverlay.show();
      await _sekolahService.deleteKalenderAkademik(id);
      await fetchKalenderAkademik();
      MBGLoadingOverlay.hide();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Event kalender berhasil dihapus',
      );
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(title: 'Gagal', message: e.toString());
    }
  }
}
