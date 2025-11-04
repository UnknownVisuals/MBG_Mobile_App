import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_siswa_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';

class SekolahController extends GetxController {
  final SekolahService _sekolahService = Get.find<SekolahService>();

  // Drawer navigation index
  final RxInt drawerSelectedIndex = 0.obs;

  // Observable variables
  final RxList<SekolahSiswaModel> students = <SekolahSiswaModel>[].obs;
  final RxList<SekolahKelasModel> classes = <SekolahKelasModel>[].obs;
  final RxList<SekolahPengirimanModel> deliveries =
      <SekolahPengirimanModel>[].obs;
  final RxBool isLoading = false.obs;

  /// Fetch students
  Future<void> fetchStudents(String sekolahId) async {
    try {
      isLoading.value = true;
      students.value = await _sekolahService.getSiswaBySekolah(sekolahId);
    } catch (e) {
      Get.log('Error fetching students: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch classes
  Future<void> fetchClasses(String sekolahId) async {
    try {
      isLoading.value = true;
      classes.value = await _sekolahService.getKelasBySekolah(sekolahId);
    } catch (e) {
      Get.log('Error fetching classes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Scan QR code for receiving delivery
  Future<void> scanSekolahQR(String qrCodeId) async {
    try {
      isLoading.value = true;
      final pengiriman = await _sekolahService.scanSekolahQR(qrCodeId);
      final index = deliveries.indexWhere(
        (delivery) => delivery.id == pengiriman.id,
      );
      if (index >= 0) {
        deliveries[index] = pengiriman;
      } else {
        deliveries.insert(0, pengiriman);
      }
    } catch (e) {
      Get.log('Error scanning sekolah QR: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
