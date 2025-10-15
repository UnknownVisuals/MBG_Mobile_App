import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isObscurePassword = true.obs;
  RxBool isRememberMe = false.obs;

  void toggleObscurePassword() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  void toggleRememberMe(bool? value) {
    isRememberMe.value = value ?? !isRememberMe.value;
  }
}
