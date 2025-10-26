import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:mbg_mobile_app/features/authentication/screens/login/widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: MBGSpacingStyles.paddingWithAppBarHeight,
        child: Column(
          children: [
            // Logo, Title, & Subtitle
            const LoginHeader(),

            // Form Fields
            const LoginForm(),

            // Divider
            // MBGFormDivider(dividerText: MBGTexts.orSignInWith.capitalize!),
            // const SizedBox(height: MBGSizes.spaceBtwSections),

            // Signin with Socials
            // const MBGSocialButtons(),
          ],
        ),
      ),
    );
  }
}
