import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_tray_return_model.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';

class DapurTrayReturnController extends GetxController {
  final DapurService _dapurService = Get.find<DapurService>();

  // Data
  final RxList<DapurTrayReturnModel> trayReceives =
      <DapurTrayReturnModel>[].obs;

  // State
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrayReceives();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<DapurTrayReturnModel> get filteredTrayReceives {
    if (selectedFilter.value == 'all') {
      return trayReceives;
    }
    return trayReceives
        .where((item) => item.status == selectedFilter.value)
        .toList();
  }

  int get totalCount => trayReceives.length;
  int get menungguPickupCount =>
      trayReceives.where((item) => item.status == 'MENUNGGU_PICKUP').length;
  int get sedangReturnCount =>
      trayReceives.where((item) => item.status == 'SEDANG_RETURN').length;
  int get sampaiDapurCount =>
      trayReceives.where((item) => item.status == 'SAMPAI_DAPUR').length;

  Future<void> fetchTrayReceives() async {
    try {
      isLoading.value = true;
      final results = await _dapurService.getMyTrayReceives();
      trayReceives.assignAll(results);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat daftar pengembalian',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> receiveTray(String qrCodeId) async {
    try {
      MBGLoadingOverlay.show();

      final newReceive = await _dapurService.receiveTrayReturn(qrCodeId);

      MBGLoadingOverlay.hide();

      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengembalian tray berhasil diterima.',
      );

      // Refresh or add to list
      trayReceives.insert(0, newReceive);
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal menerima tray',
        message: e.toString(),
      );
    }
  }
}
