import 'package:cinema_app/features/authetication/controllers/login/login_controller.dart';
import 'package:cinema_app/features/authetication/screens/password/forget_password.dart';
import 'package:cinema_app/features/authetication/screens/signup/signup.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:cinema_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart'; // Ensure you have Iconsax for the icons

class MyLoginForm extends StatelessWidget {
  const MyLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // For large screens, constrain the width and center it
        double formWidth = constraints.maxWidth < 600 ? double.infinity : 400;

        return Form(
          key: controller.loginFormKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: MySizes.spaceBtwSections),
              child: SizedBox(
                width: formWidth, // Responsive width
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => MyValidator.validateEmail(value),
                      decoration: const InputDecoration(
                        labelText: MyTexts.email, // Provide the text from TextStrings
                      ),
                    ),
                    const SizedBox(height: MySizes.spaceBtwInputFields),

                    // Password
                    Obx(
                      () => TextFormField(
                        controller: controller.password,
                        validator: (value) => MyValidator.validateEmptyText('Password', value),
                        obscureText: controller.hidePassword.value, // Adding password obscuring
                        decoration: InputDecoration(
                          labelText: MyTexts.password,
                          suffixIcon: IconButton(  
                            onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                            icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: MySizes.spaceBtwItems / 5),

                    // Remember Me and Forget Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Remember Me
                        Row(
                          children: [
                            Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)),
                            const Text(MyTexts.rememberMe),
                          ],
                        ),
                        // Forget Password
                        TextButton(
                          onPressed: () => Get.to(() => const ForgetPassword()),
                          child: const Text(MyTexts.forgotPassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: MySizes.spaceBtwSections * 1.5),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.emailAndPasswordLogin(),
                        child: const Text(MyTexts.signIn),
                      ),
                    ),
                    const SizedBox(height: MySizes.spaceBtwSections),
                    
                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Get.to(() => const SignUpScreen()),
                        child: const Text(MyTexts.createAccount),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
