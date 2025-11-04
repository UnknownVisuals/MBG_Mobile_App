import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class SekolahReceiveDeliveryController extends GetxController {
  SekolahReceiveDeliveryController()
    : _sekolahService = Get.find<SekolahService>();

  final SekolahService _sekolahService;

  final RxBool isProcessing = false.obs;

  bool beginProcessing() {
    if (isProcessing.value) return false;
    isProcessing.value = true;
    return true;
  }

  void endProcessing() {
    isProcessing.value = false;
  }

  Future<SekolahPengirimanModel?> confirmScan(String code) async {
    try {
      final pengiriman = await _sekolahService.scanSekolahQR(code);
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengiriman berhasil diterima!',
      );
      return pengiriman;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memproses QR: $e',
      );
      return null;
    }
  }
}
