import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DapurInfoController extends GetxController {
  // Dependencies
  final MBGHttpHelper httpHelper = Get.put(MBGHttpHelper());

  final UserModel userModel = Get.find<UserController>().user.value!;
  String get dapurId => userModel.dapurAsPIC.first.id;

  // Data Variables
  Rx<DapurInfoModel?> dapurInfo = Rx<DapurInfoModel?>(null);

  // State Variables
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-load dapur info when controller is initialized
    if (userModel.dapurAsPIC.isNotEmpty) {
      fetchDapurInfo(dapurId: dapurId);
    }
  }

  /// Fetch dapur info from API
  Future<void> fetchDapurInfo({required String dapurId}) async {
    try {
      isLoading.value = true;

      MBGHttpHelper.loadSessionToken();

      final response = await httpHelper.getRequest('dapur/$dapurId');

      if (response.statusCode == 200) {
        final responseData = response.body;

        if (responseData['success'] == true) {
          dapurInfo.value = DapurInfoModel.fromJson(responseData['data']);
        }
      }
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
