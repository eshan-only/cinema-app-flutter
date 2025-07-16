import 'package:cinema_app/features/personalization/controllers/user_controller.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:cinema_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart'; // Assuming Iconsax icons are used

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Re-Authenticate User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Form(
          key: controller.reAuthFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.verifyEmail,
                validator: MyValidator.validateEmail,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: MyTexts.email,
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwInputFields),
              Obx(
                () => TextFormField(
                  obscureText: controller.hidePassword.value,
                  controller: controller.verifyPassword,
                  validator: (value) => MyValidator.validateEmptyText('Password', value),
                  decoration: InputDecoration(
                    labelText: MyTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(
                        controller.hidePassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwSections),
              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.reAuthenticateEmailAndPasswordUser(),
                  child: const Text('Verify'),
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
