import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/models/absensi_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/kelas_model.dart';
import 'package:mbg_mobile_app/utils/http/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:intl/intl.dart';

class AbsensiController extends GetxController {
  final SekolahService _sekolahService = Get.find<SekolahService>();

  // Observable variables
  final RxList<KelasModel> kelasList = <KelasModel>[].obs;
  final Rx<KelasModel?> selectedKelas = Rx<KelasModel?>(null);
  final RxList<AbsensiModel> absensiHistory = <AbsensiModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Statistics
  final RxInt totalPresent = 0.obs;
  final RxInt totalClasses = 0.obs;

  /// Set available classes
  void setKelasList(List<KelasModel> classes) {
    kelasList.value = classes;
  }

  /// Fetch absensi history for selected class
  Future<void> fetchAbsensiHistory(String kelasId) async {
    try {
      isLoadingHistory.value = true;
      final history = await _sekolahService.getAbsensiByKelas(kelasId);
      absensiHistory.value = history;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch attendance history: ${e.toString()}',
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Fetch total attendance for a specific date
  Future<void> fetchTotalAbsensi(String sekolahId, DateTime date) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final result = await _sekolahService.getTotalAbsensi(sekolahId, dateStr);

      totalPresent.value = result['totalHadir'] ?? 0;
      totalClasses.value = result['totalKelas'] ?? 0;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch total attendance: ${e.toString()}',
      );
    }
  }

  /// Create attendance record
  Future<bool> createAbsensi({
    required String kelasId,
    required DateTime tanggal,
    required int jumlahHadir,
  }) async {
    try {
      isLoading.value = true;

      final dateStr = DateFormat('yyyy-MM-dd').format(tanggal);

      await _sekolahService.createAbsensi(kelasId, {
        'tanggal': dateStr,
        'jumlahHadir': jumlahHadir,
      });

      MBGLoaders.successSnackBar(
        title: 'Success',
        message: 'Attendance recorded successfully',
      );

      // Refresh history
      await fetchAbsensiHistory(kelasId);

      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to record attendance: ${e.toString()}',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a class to view its attendance
  void selectKelas(KelasModel kelas) {
    selectedKelas.value = kelas;
    fetchAbsensiHistory(kelas.id);
  }

  /// Clear selected class
  void clearSelection() {
    selectedKelas.value = null;
    absensiHistory.clear();
  }

  /// Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  /// Check if attendance exists for a specific date
  bool hasAttendanceForDate(DateTime date) {
    return absensiHistory.any(
      (absensi) =>
          absensi.tanggal.year == date.year &&
          absensi.tanggal.month == date.month &&
          absensi.tanggal.day == date.day,
    );
  }

  /// Get attendance for a specific date
  AbsensiModel? getAttendanceForDate(DateTime date) {
    try {
      return absensiHistory.firstWhere(
        (absensi) =>
            absensi.tanggal.year == date.year &&
            absensi.tanggal.month == date.month &&
            absensi.tanggal.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }
}
