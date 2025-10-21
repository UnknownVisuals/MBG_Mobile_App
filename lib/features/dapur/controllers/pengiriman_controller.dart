import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../utils/http/dapur_service.dart';
import '../../../utils/http/sekolah_service.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/constants/image_strings.dart';
import '../models/pengiriman_model.dart';
import '../../sekolah/models/sekolah_model.dart';

class PengirimanController extends GetxController {
  static PengirimanController get instance => Get.find();

  final DapurService _dapurService = Get.find<DapurService>();
  final SekolahService _sekolahService = Get.find<SekolahService>();

  // Observable lists
  final RxList<PengirimanModel> allPengiriman = <PengirimanModel>[].obs;
  final RxList<PengirimanModel> pendingPengiriman = <PengirimanModel>[].obs;
  final RxList<PengirimanModel> inTransitPengiriman = <PengirimanModel>[].obs;
  final RxList<PengirimanModel> completedPengiriman = <PengirimanModel>[].obs;
  final RxList<SekolahModel> sekolahList = <SekolahModel>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSekolah = false.obs;

  // Counts
  final RxInt pendingCount = 0.obs;
  final RxInt inTransitCount = 0.obs;
  final RxInt completedTodayCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPengiriman();
    fetchSekolahList();
  }

  /// Fetch all pengiriman and categorize them
  Future<void> fetchPengiriman() async {
    try {
      isLoading.value = true;
      final pengirimanList = await _dapurService.getAllPengiriman();
      allPengiriman.value = pengirimanList;

      // Categorize by status
      pendingPengiriman.value = pengirimanList
          .where((p) => p.status == 'PENDING')
          .toList();
      inTransitPengiriman.value = pengirimanList
          .where((p) => p.status == 'DIAMBIL')
          .toList();
      completedPengiriman.value = pengirimanList
          .where((p) => p.status == 'DITERIMA')
          .toList();

      // Update counts
      pendingCount.value = pendingPengiriman.length;
      inTransitCount.value = inTransitPengiriman.length;

      // Count completed today
      final today = DateTime.now();
      completedTodayCount.value = completedPengiriman
          .where(
            (p) =>
                p.waktuDiterima != null &&
                p.waktuDiterima!.year == today.year &&
                p.waktuDiterima!.month == today.month &&
                p.waktuDiterima!.day == today.day,
          )
          .length;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat data pengiriman: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch list of sekolah for dropdown
  Future<void> fetchSekolahList() async {
    try {
      isLoadingSekolah.value = true;
      final schools = await _sekolahService.getAllSekolah();
      sekolahList.value = schools;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat data sekolah: $e',
      );
    } finally {
      isLoadingSekolah.value = false;
    }
  }

  /// Create new pengiriman
  Future<bool> createPengiriman({
    required String sekolahId,
    required int jumlahTray,
    required int jumlahKeranjang,
  }) async {
    try {
      MBGFullScreenLoader.openLoadingDialog(
        'Membuat pengiriman...',
        MBGImages.onBoardingImage1,
      );

      await _dapurService.createPengiriman({
        'sekolahId': sekolahId,
        'jumlahTray': jumlahTray,
        'jumlahKeranjang': jumlahKeranjang,
      });

      MBGFullScreenLoader.stopLoading();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengiriman berhasil dibuat',
      );

      // Refresh the list
      await fetchPengiriman();
      return true;
    } catch (e) {
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal membuat pengiriman: $e',
      );
      return false;
    }
  }

  /// Delete pengiriman (only for PENDING status)
  Future<bool> deletePengiriman(PengirimanModel pengiriman) async {
    try {
      if (pengiriman.status != 'PENDING') {
        MBGLoaders.warningSnackBar(
          title: 'Peringatan',
          message: 'Hanya pengiriman dengan status PENDING yang dapat dihapus',
        );
        return false;
      }

      MBGFullScreenLoader.openLoadingDialog(
        'Menghapus pengiriman...',
        MBGImages.onBoardingImage1,
      );

      await _dapurService.deletePengiriman(pengiriman.id);

      MBGFullScreenLoader.stopLoading();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengiriman berhasil dihapus',
      );

      // Refresh the list
      await fetchPengiriman();
      return true;
    } catch (e) {
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal menghapus pengiriman: $e',
      );
      return false;
    }
  }

  /// Get pengiriman by ID
  Future<PengirimanModel?> getPengirimanById(String id) async {
    try {
      return await _dapurService.getPengirimanById(id);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat detail pengiriman: $e',
      );
      return null;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await Future.wait([fetchPengiriman(), fetchSekolahList()]);
  }

  /// Get status color
  Color getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'DIAMBIL':
        return Colors.blue;
      case 'DITERIMA':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Get status text
  String getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'Menunggu Pengambilan';
      case 'DIAMBIL':
        return 'Sedang Dikirim';
      case 'DITERIMA':
        return 'Sudah Diterima';
      default:
        return status;
    }
  }

  /// Get status icon
  IconData getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Icons.schedule;
      case 'DIAMBIL':
        return Icons.local_shipping;
      case 'DITERIMA':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }
}
