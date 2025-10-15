import 'package:get/get.dart';

class SignupController extends GetxController {
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var agreeTnC = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void toggleAgreeToC(bool? value) {
    agreeTnC.value = value ?? false;
  }
}
