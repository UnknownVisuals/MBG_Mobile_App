import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/login_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependencies
    final LoginController loginController = Get.put(LoginController());

    // Inputs Variables
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Form Key
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Obx(
      () => Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: MBGSizes.spaceBtwSections,
          ),
          child: Column(
            children: [
              // Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.direct_right),
                  labelText: 'email'.tr,
                ),
                validator: (value) => MBGValidator.validateEmail(value),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: loginController.isObscurePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: MBGTexts.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      loginController.isObscurePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                    onPressed: loginController.toggleObscurePassword,
                  ),
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields / 2),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember Me
                  Row(
                    children: [
                      Checkbox(
                        value: loginController.isRememberMe.value,
                        onChanged: loginController.toggleRememberMe,
                      ),
                      Text(MBGTexts.rememberMe),
                    ],
                  ),

                  // Forgot Password
                  // TextButton(
                  //   onPressed: () => Get.to(const ForgetPasswordScreen()),
                  //   child: Text(
                  //     MBGTexts.forgetPassword,
                  //     style: const TextStyle(color: MBGColors.primary),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Signin Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    loginController.login(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  },
                  child: Text(MBGTexts.signIn),
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),

              // Create Account Button
              // SizedBox(
              //   width: double.infinity,
              //   child: OutlinedButton(
              //     onPressed: () => Get.to(const SignupScreen()),
              //     child: Text(MBGTexts.createAccount),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
