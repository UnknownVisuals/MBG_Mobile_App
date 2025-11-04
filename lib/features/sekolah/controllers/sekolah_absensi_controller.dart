import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_absensi_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class SekolahAbsensiController extends GetxController {
  SekolahAbsensiController({
    SekolahService? sekolahService,
    UserController? userController,
  }) : _sekolahService = sekolahService ?? Get.find<SekolahService>(),
       _userController = userController ?? Get.find<UserController>();

  final SekolahService _sekolahService;
  final UserController _userController;

  final RxList<SekolahKelasModel> kelasList = <SekolahKelasModel>[].obs;
  final Rx<SekolahKelasModel?> selectedKelas = Rx<SekolahKelasModel?>(null);
  final RxList<SekolahAbsensiModel> absensiHistory =
      <SekolahAbsensiModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final RxInt totalPresent = 0.obs;
  final RxInt totalClasses = 0.obs;

  String? get _sekolahId {
    final sekolahAsPic = _userController.userModel.value?.sekolahAsPIC;
    if (sekolahAsPic == null || sekolahAsPic.isEmpty) {
      return null;
    }
    return sekolahAsPic.first.id;
  }

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await loadClasses();
    await _refreshTotals();
  }

  Future<void> loadClasses() async {
    final sekolahId = _sekolahId;
    if (sekolahId == null) {
      kelasList.clear();
      selectedKelas.value = null;
      absensiHistory.clear();
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Anda tidak memiliki akses ke sekolah',
      );
      return;
    }

    try {
      isLoading.value = true;
      final previousSelection = selectedKelas.value?.id;
      final classes = await _sekolahService.getKelasBySekolah(sekolahId);
      kelasList.assignAll(classes);

      SekolahKelasModel? nextSelection;
      if (previousSelection != null) {
        for (final kelas in kelasList) {
          if (kelas.id == previousSelection) {
            nextSelection = kelas;
            break;
          }
        }
      }
      nextSelection ??= kelasList.isNotEmpty ? kelasList.first : null;
      selectedKelas.value = nextSelection;

      if (nextSelection != null) {
        await fetchAbsensiHistory(nextSelection.id);
      } else {
        absensiHistory.clear();
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat kelas: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAll() async {
    await loadClasses();
    await _refreshTotals();
  }

  Future<void> fetchAbsensiHistory(String kelasId) async {
    try {
      isLoadingHistory.value = true;
      final history = await _sekolahService.getAbsensiByKelas(kelasId);
      absensiHistory.value = history;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch attendance history: $e',
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> _refreshTotals() async {
    final sekolahId = _sekolahId;
    if (sekolahId == null) {
      totalPresent.value = 0;
      totalClasses.value = 0;
      return;
    }
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final result = await _sekolahService.getTotalAbsensi(sekolahId, dateStr);

      totalPresent.value = result['totalHadir'] ?? 0;
      totalClasses.value = result['totalKelas'] ?? 0;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch total attendance: $e',
      );
    }
  }

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

      await fetchAbsensiHistory(kelasId);
      await _refreshTotals();

      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to record attendance: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void selectKelas(SekolahKelasModel kelas) {
    selectedKelas.value = kelas;
    fetchAbsensiHistory(kelas.id);
  }

  void clearSelection() {
    selectedKelas.value = null;
    absensiHistory.clear();
  }

  Future<void> setSelectedDate(DateTime date) async {
    selectedDate.value = date;
    await _refreshTotals();
    final current = selectedKelas.value;
    if (current != null) {
      await fetchAbsensiHistory(current.id);
    }
  }

  bool hasAttendanceForDate(DateTime date) {
    return absensiHistory.any(
      (absensi) =>
          absensi.tanggal.year == date.year &&
          absensi.tanggal.month == date.month &&
          absensi.tanggal.day == date.day,
    );
  }

  SekolahAbsensiModel? getAttendanceForDate(DateTime date) {
    try {
      return absensiHistory.firstWhere(
        (absensi) =>
            absensi.tanggal.year == date.year &&
            absensi.tanggal.month == date.month &&
            absensi.tanggal.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }
}
