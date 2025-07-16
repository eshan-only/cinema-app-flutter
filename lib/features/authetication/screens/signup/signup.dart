import 'package:cinema_app/common/widgets/login_signup/form_divider.dart';
import 'package:cinema_app/common/widgets/login_signup/social_buttons.dart';
import 'package:cinema_app/features/authetication/screens/signup/widgets/sign_up_form.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark or light
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Adding a back button in the AppBar
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black, // Set color based on theme
          ),
          onPressed: () {
            // Go back to the previous screen
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(child: Text(MyTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium)),
              const SizedBox(height: MySizes.spaceBtwSections),
              // Form
              const SignUpForm(),
              const SizedBox(height: MySizes.spaceBtwSections),
              // Divider
              FormDivider(text: MyTexts.orSignUpWith.capitalize!),
              const SizedBox(height: MySizes.spaceBtwItems),
              // Footer
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
