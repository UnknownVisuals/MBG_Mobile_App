import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/login_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class LoginController extends GetxController {
  // Dependencies
  final MBGHttpHelper httpHelper = Get.put(MBGHttpHelper());
  final UserController userController = Get.put(UserController());

  // State Variables
  RxBool isObscurePassword = true.obs;
  RxBool isRememberMe = false.obs;
  RxBool isLoading = false.obs;

  // Toggle password visibility
  void toggleObscurePassword() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    isRememberMe.value = value ?? !isRememberMe.value;
  }

  /// Perform login action
  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;

    try {
      // Create login model
      final LoginModel loginModel = LoginModel(
        email: email,
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
          // Extract token
          final String token = responseData['data']['token'] as String;

          // Save token based on remember me preference
          await MBGHttpHelper.setSessionToken(
            token,
            persist: isRememberMe.value,
          );

          // Fetch complete user profile from auth/me endpoint
          await userController.fetchUserProfile();

          // Navigate based on user role
          final userRole = userController.userModel.value?.role;

          if (userRole == 'PIC_DAPUR') {
            Get.offAll(() => const DapurScreen());
          } else if (userRole == 'DRIVER') {
            Get.offAll(() => const DriverScreen());
          } else if (userRole == 'PIC_SEKOLAH') {
            Get.offAll(() => const SekolahScreen());
          }

          // Show success message
          MBGLoaders.successSnackBar(
            title: 'Login Berhasil',
            message: 'Selamat datang, ${userController.userModel.value}!',
          );
        } else {
          MBGLoaders.errorSnackBar(
            title: 'Login Gagal',
            message: responseData['message'],
          );
        }
      } else {
        MBGLoaders.errorSnackBar(
          title: 'Login Gagal',
          message: loginResponse.body['message'],
        );
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Login Gagal', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
