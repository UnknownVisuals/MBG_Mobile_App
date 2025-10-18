import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/models/login_model.dart';
import 'package:mbg_mobile_app/navigation_menu.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/local_storage/storage_utility.dart';
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
          await MBGHttpHelper.setSessionToken(
            token,
            persist: isRememberMe.value,
          );

          MBGLocalStorage localStorage = MBGLocalStorage();
          final String tokenStorage =
              localStorage.readData<String>('session_token') ?? '';

          await MBGLoaders.successSnackBar(
            title: 'Login Successful',
            message:
                'Welcome back, ${responseData['data']['user']['name']}!\nToken: $tokenStorage',
          );

          Get.offAll(() => const NavigationMenu());
        } else {
          MBGLoaders.errorSnackBar(
            title: 'Login Failed',
            message: responseData?['message'] ?? 'Invalid response format',
          );
        }
      } else {
        MBGLoaders.errorSnackBar(
          title: 'Login Failed',
          message: loginResponse.body?['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Login Failed', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
