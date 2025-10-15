import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/screens/success_screen.dart';
import 'package:mbg_mobile_app/features/authentication/screens/login/login.dart';
import 'package:mbg_mobile_app/utils/constants/image_strings.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(const LoginScreen()),
            icon: const Icon(Iconsax.close_circle),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(MBGImages.logo),
                width: MBGHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Title & SubTitle
              Text(
                MBGTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              Text(
                'support@mbg.gov.id',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              Text(
                MBGTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(
                    MBGSuccessScreen(
                      image: MBGImages.logo,
                      title: MBGTexts.yourAccountCreatedTitle,
                      subTitle: MBGTexts.yourAccountCreatedSubTitle,
                      onPressed: () => Get.offAll(const LoginScreen()),
                    ),
                  ),
                  child: Text(MBGTexts.tContinue),
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(MBGTexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
