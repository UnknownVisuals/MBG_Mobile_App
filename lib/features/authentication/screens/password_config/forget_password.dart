import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/authentication/screens/password_config/reset_password.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headings
              Text(
                MBGTexts.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              Text(
                MBGTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections * 2),

              // TextFields
              TextFormField(
                decoration: InputDecoration(
                  labelText: MBGTexts.email,
                  prefixIcon: const Icon(Iconsax.direct_right),
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.off(const ResetPasswordScreen()),
                  child: Text(MBGTexts.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
