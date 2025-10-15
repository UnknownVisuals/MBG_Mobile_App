import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/form_divider.dart';
import 'package:mbg_mobile_app/common/widgets/social_button.dart';
import 'package:mbg_mobile_app/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = MBGHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          color: dark ? MBGColors.white : MBGColors.black,
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                MBGTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Form Fields
              const SignupForm(),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Divider
              MBGFormDivider(dividerText: MBGTexts.orSignUpWith.capitalize!),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Signup with Socials
              const MBGSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
