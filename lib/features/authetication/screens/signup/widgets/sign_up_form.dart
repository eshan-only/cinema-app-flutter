import 'package:cinema_app/features/authetication/controllers/sign_up/sign_up_controller.dart';
import 'package:cinema_app/features/authetication/screens/signup/widgets/terms_and_conditons_checkbox.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:cinema_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // For large screens, constrain the width and center it
        double formWidth = constraints.maxWidth < 600 ? double.infinity : 400;

        return Form(
          key: controller.signupFormKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: MySizes.spaceBtwSections),
              child: SizedBox(
                width: formWidth, // Responsive width
                child: Column(
                  children: [
                    // First Name and Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstName,
                            validator: (value) => MyValidator.validateEmptyText('First name', value),
                            decoration: const InputDecoration(
                              labelText: MyTexts.firstName,
                            ),
                          ),
                        ),
                        const SizedBox(width: MySizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastName,
                            validator: (value) => MyValidator.validateEmptyText('Last name', value),
                            decoration: const InputDecoration(
                              labelText: MyTexts.lastName,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MySizes.spaceBtwInputFields),
                    
                    // Username
                    TextFormField(
                      controller: controller.username,
                      validator: (value) => MyValidator.validateEmptyText('Username', value),
                      decoration: const InputDecoration(
                        labelText: MyTexts.username,
                      ),
                    ),
                    const SizedBox(height: MySizes.spaceBtwInputFields),

                    // Email
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => MyValidator.validateEmail(value),
                      decoration: const InputDecoration(
                        labelText: MyTexts.email,
                      ),
                    ),
                    const SizedBox(height: MySizes.spaceBtwInputFields),

                    // Phone
                    TextFormField(
                      controller: controller.phoneNumber,
                      validator: (value) => MyValidator.validatePhoneNumber(value),
                      decoration: const InputDecoration(
                        labelText: MyTexts.phoneNo,
                      ),
                    ),
                    const SizedBox(height: MySizes.spaceBtwInputFields),

                    // Password
                    Obx(
                      () => TextFormField(
                        controller: controller.password,
                        validator: (value) => MyValidator.validatePassword(value),
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
                    const SizedBox(height: MySizes.spaceBtwInputFields),

                    // Terms and Conditions Checkbox
                    const TermsNConditonsCheckBox(),
                    
                    const SizedBox(height: MySizes.spaceBtwSections),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.signup(),
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
