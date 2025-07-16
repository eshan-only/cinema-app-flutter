import 'package:cinema_app/common/styles/spacing_styles.dart';
import 'package:cinema_app/common/widgets/login_signup/form_divider.dart';
import 'package:cinema_app/features/authetication/screens/login/widgets/login_header.dart';
import 'package:cinema_app/common/widgets/login_signup/social_buttons.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/features/authetication/screens/login/widgets/login_form.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: MySpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Header
              const LoginHeader(),
              const SizedBox(height: MySizes.spaceBtwSections/2),
              // Form
              const MyLoginForm(),
              const SizedBox(height: MySizes.spaceBtwSections),

              // Divider
              FormDivider(text: MyTexts.orSignInWith.capitalizeFirst!),  // Use capitalizeFirst from GetX for safer usage
              const SizedBox(height: MySizes.spaceBtwSections),

              // Footer
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
