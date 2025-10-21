import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/models/kelas_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/siswa_model.dart';
import 'package:mbg_mobile_app/utils/http/sekolah_service.dart';

class SekolahController extends GetxController {
  final SekolahService _sekolahService = Get.find<SekolahService>();

  // Drawer navigation index
  final RxInt drawerSelectedIndex = 0.obs;

  // Observable variables
  final RxList<SiswaModel> students = <SiswaModel>[].obs;
  final RxList<KelasModel> classes = <KelasModel>[].obs;
  final RxList<dynamic> deliveries = <dynamic>[].obs;
  final RxBool isLoading = false.obs;

  /// Fetch students
  Future<void> fetchStudents(String sekolahId) async {
    try {
      isLoading.value = true;
      students.value = await _sekolahService.getSiswaBySekolah(sekolahId);
    } catch (e) {
      print('Error fetching students: $e');
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
      print('Error fetching classes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Scan QR code for receiving delivery
  Future<void> scanSekolahQR(String qrCodeId) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // await httpHelper.postRequest('pengiriman/$qrCodeId/scan-sekolah', {});
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
