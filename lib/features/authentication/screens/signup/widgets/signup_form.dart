import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/signup_controller.dart';
import 'package:mbg_mobile_app/features/authentication/screens/signup/verify_email.dart';
import 'package:mbg_mobile_app/features/authentication/screens/signup/widgets/term_and_conditions.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());

    return Form(
      child: Column(
        children: [
          // First Name & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: InputDecoration(
                    labelText: MBGTexts.firstName,
                    prefixIcon: const Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: InputDecoration(
                    labelText: MBGTexts.lastName,
                    prefixIcon: const Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MBGSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            expands: false,
            decoration: InputDecoration(
              labelText: MBGTexts.username,
              prefixIcon: const Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: MBGSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            expands: false,
            decoration: InputDecoration(
              labelText: MBGTexts.email,
              prefixIcon: const Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: MBGSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            expands: false,
            decoration: InputDecoration(
              labelText: MBGTexts.phoneNo,
              prefixIcon: const Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: MBGSizes.spaceBtwInputFields),

          // Password
          Obx(
            () => TextFormField(
              expands: false,
              obscureText: signupController.obscurePassword.value,
              decoration: InputDecoration(
                labelText: MBGTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  icon: Icon(
                    signupController.obscurePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                  onPressed: signupController.togglePasswordVisibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: MBGSizes.spaceBtwInputFields),

          // Confirm Password
          Obx(
            () => TextFormField(
              expands: false,
              obscureText: signupController.obscureConfirmPassword.value,
              decoration: InputDecoration(
                labelText: MBGTexts.confirmPassword,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  icon: Icon(
                    signupController.obscureConfirmPassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                  onPressed: signupController.toggleConfirmPasswordVisibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: MBGSizes.spaceBtwSections),

          // Agree to Terms & Conditions
          const TermAndConditions(),
          const SizedBox(height: MBGSizes.spaceBtwSections),

          // Signup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(const VerifyEmailScreen()),
              child: Text(MBGTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
