import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DapurInfoController extends GetxController {
  // Dependencies
  final DapurService dapurService = Get.put(DapurService());

  // Getter for dapurId
  final UserModel userModel = Get.find<UserController>().userModel.value!;
  String get dapurId {
    return userModel.dapurAsPIC.first.id;
  }

  // Data Variables
  Rx<DapurInfoModel?> dapurInfo = Rx<DapurInfoModel?>(null);

  // State Variables
  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchDapurInfo(dapurId: dapurId);
  }

  // =======================
  // REFRESH DAPUR INFO DATA
  // =======================
  Future<void> refreshDapurInfo() async {
    await fetchDapurInfo(dapurId: dapurId);
  }

  // ===================
  // GET DAPUR INFO DATA
  // ===================
  Future<void> fetchDapurInfo({required String dapurId}) async {
    try {
      isLoading.value = true;
      final info = await dapurService.getDapurById(dapurId);
      dapurInfo.value = info;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat profil dapur',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
