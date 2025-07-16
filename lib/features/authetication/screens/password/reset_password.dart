import 'package:cinema_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cinema_app/features/authetication/controllers/forgetPassword/forget_password_controller.dart';
import 'package:cinema_app/features/authetication/screens/login/login.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController()); // Use ForgetPasswordController here
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => AuthenticationRepository.instance.logout()),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(MyImgStrings.verifyEmail),
                width: MyHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: MySizes.spaceBtwSections),

              // Title and Subtitle
              Text(
                email,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwItems * 2),
              Text(
                MyTexts.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwItems * 2),
              Text(
                MyTexts.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwSections),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => LoginScreen()),
                  child: const Text(MyTexts.done),
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwItems * 1.5),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => controller.resendPasswordResetEmail(email), // Call the method here
                  child: const Text(MyTexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
