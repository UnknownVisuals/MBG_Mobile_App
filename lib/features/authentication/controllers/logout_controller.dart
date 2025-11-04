import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/authentication/screens/login/login.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class LogoutController extends GetxController {
  // Dependencies
  final MBGHttpHelper httpHelper = Get.find<MBGHttpHelper>();

  // Data Variables
  Rx<UserModel?> user = Rx<UserModel?>(null);

  // State Variables
  RxBool isLoading = false.obs;

  /// Clear user data on logout
  Future<void> logout() async {
    try {
      await MBGHttpHelper.clearSessionToken();

      user.value = null;

      Get.offAll(() => const LoginScreen());

      MBGLoaders.successSnackBar(
        title: 'Logout Berhasil',
        message: 'Sampai jumpa lagi!',
      );
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Logout Failed', message: e.toString());
    }
  }
}
