import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class UserController extends GetxController {
  // Dependencies
  final MBGHttpHelper httpHelper = Get.find<MBGHttpHelper>();

  // Data Variables
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  // State Variables
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Fetch user profile from API
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      MBGHttpHelper.loadSessionToken();

      final response = await httpHelper.getRequest('auth/me');

      if (response.statusCode == 200) {
        final responseData = response.body;

        if (responseData['success'] == true) {
          userModel.value = UserModel.fromJson(responseData['data']);
        }
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat profil pengguna',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
