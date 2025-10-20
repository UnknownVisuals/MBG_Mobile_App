import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/login_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah.dart';
import 'package:mbg_mobile_app/navigation_menu.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class LoginController extends GetxController {
  final MBGHttpHelper httpHelper = MBGHttpHelper();

  RxBool isObscurePassword = true.obs;
  RxBool isRememberMe = false.obs;
  RxBool isLoading = false.obs;

  void toggleObscurePassword() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  void toggleRememberMe(bool? value) {
    isRememberMe.value = value ?? !isRememberMe.value;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      // Create login model
      final LoginModel loginModel = LoginModel(
        email: username,
        password: password,
      );

      // Make login request
      final loginResponse = await httpHelper.postRequest(
        'auth/login',
        loginModel.toJson(),
      );

      // Handle response
      if (loginResponse.statusCode == 200) {
        final responseData = loginResponse.body;

        if (responseData['success'] == true) {
          final String token = responseData['data']['token'] as String;

          // Save token based on remember me preference
          await MBGHttpHelper.setSessionToken(
            token,
            persist: isRememberMe.value,
          );

          // Get UserController instance
          final userController = Get.put(UserController());

          // Fetch complete user profile from auth/me endpoint
          await userController.fetchUserProfile();

          // Show success message
          await MBGLoaders.successSnackBar(
            title: 'Login Successful',
            message:
                'Welcome back, ${userController.user.value?.name ?? 'User'}!',
          );

          // Navigate based on user role
          final userRole = userController.user.value?.role;

          if (userRole == 'PIC_DAPUR') {
            Get.offAll(() => const DapurScreen());
          } else if (userRole == 'DRIVER') {
            Get.offAll(() => const DriverScreen());
          } else if (userRole == 'PIC_SEKOLAH') {
            Get.offAll(() => const SekolahScreen());
          } else if (userRole == 'SUPERADMIN') {
            Get.offAll(() => const NavigationMenu());
          } else {
            Get.offAll(() => const NavigationMenu());
          }
        } else {
          MBGLoaders.errorSnackBar(
            title: 'Login Failed',
            message: responseData['message'],
          );
        }
      } else {
        MBGLoaders.errorSnackBar(
          title: 'Login Failed',
          message: loginResponse.body['message'],
        );
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Login Failed', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
